#!/bin/sh

dir=$(cd "${0%[/\\]*}" > /dev/null; pwd)

# Change to this root durectory
cd "$dir"
current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [ $current_branch != "master" ]; then
    echo "You must be on the master branch"
    exit 1
fi

# Check there are no changes to stage or commit
if [ ! -z "$(git status --porcelain)" ]; then
    echo "WARNING: Uncommitted changes on master branch"
fi

# See if we were passed a specific version
if [ $# -ne 0 ]; then
    tag="$1"
    if [ ! $(git tag -l "$tag") ]; then
        echo "Version tag not found"
        exit 1
    fi
else
    tag=$(git tag | sort -V | tail -1)
    if [ -z "$tag" ]; then
        echo "Version tag not found"
        exit 1
    fi
fi

# Get the date of the tag's commit
sha=$(git rev-parse $tag)
date=$(git log -1 --date=short --pretty=format:%cd $sha)

doc_basename=civl-fr-spec
doc=$doc_basename.adoc
doc_release=tmp-$doc_basename-$tag.adoc
pdf_release=releases/$doc_basename-$tag.pdf
html_release=releases/$doc_basename-$tag.html

function convert_to_pdf {

    asciidoctor-pdf -o "$pdf_release" -a "release=$tag" -a "docdate=$date" "$doc_release"
    if [ $? -ne 0 ]; then
        echo "asciidoctor-pdf failed"
        return 1
    fi

    return 0
}

function convert_to_html {

    asciidoctor -o "$html_release" -a "release=$tag" -a "docdate=$date" "$doc_release"

    if [ $? -ne 0 ]; then
        echo "asciidoctor failed"
        return 1
    fi

    return 0
}

exit_code=1

if git show $tag:$doc > "$doc_release" ; then

    if convert_to_pdf && convert_to_html ; then
        exit_code=0
    fi
fi

if [ $exit_code -eq 0 ]; then
    echo "Released ${tag}"
else
    echo "Failed to release ${tag}"
    # Clean up
    if [ -f $pdf_release ]; then
        unlink $pdf_release
    fi
    if [ -f $html_release ]; then
        unlink $html_release
    fi
fi

unlink $doc_release
exit $exit_code
