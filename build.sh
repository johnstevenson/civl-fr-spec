#!/bin/sh

# Creates pdf and html output in the /temp directory
# from the currently checked-out branch

dir=$(cd "${0%[/\\]*}" > /dev/null; pwd)

# Change to this root directory
cd "$dir"
current_branch="$(git rev-parse --abbrev-ref HEAD)"

# Check there are no changes to stage or commit
if [ ! -z "$(git status --porcelain)" ]; then
    echo "Uncommitted changes on $current_branch branch - build aborted"
    exit 1
fi

# Get the date of the current commit
ts=$(git log -n1 --pretty=%ct HEAD)
revdate=$(date -ud "@$ts" "+%Y-%m-%d %H:%M:%S")
hash=$(git log -n1 --pretty="%h" HEAD)
revnumber=$hash-dev

doc_basename=dev-spec
doc=civl-fr-spec.adoc
pdf_release=temp/$doc_basename-$hash.pdf
html_release=temp/$doc_basename-$hash.html

function convert_to_pdf {

    asciidoctor-pdf -o "$pdf_release" -a "revnumber=$revnumber" -a "revdate=$revdate" "$doc"
    if [ $? -ne 0 ]; then
        echo "asciidoctor-pdf failed"
        return 1
    fi

    return 0
}

function convert_to_html {

    asciidoctor -o "$html_release" -a "revnumber=$revnumber" -a "revdate=$revdate" "$doc"
    if [ $? -ne 0 ]; then
        echo "asciidoctor failed"
        return 1
    fi

    return 0
}

exit_code=1

if convert_to_pdf && convert_to_html ; then
    exit_code=0
fi

build="branch: $current_branch, commit: $hash"

if [ $exit_code -eq 0 ]; then
    echo "Built $build"
    echo "   - $pdf_release"
    echo "   - $html_release"
else
    echo "Failed to build $build"
    # Clean up any output
    if [ -f $pdf_release ]; then
        unlink $pdf_release
    fi
    if [ -f $html_release ]; then
        unlink $html_release
    fi
fi

exit $exit_code
