# civl-fr-spec

Technical specification for CIVL flight recorders. The official release version is available from https://www.fai.org/civl-documents 

## About

This repo contains the source text in [asciidoc][asciidoc] format, to make it easier to work with rather than sharing a Word document.

See [civl-fr-spec.adoc](civl-fr-spec.adoc), which is the specification rendered by the Github interface (click the `Raw` button to see plain text).

Note that the `master` branch will not necessarily reflect the current version.

## Toolchain

Uses the [asciidoctor][asciidoctor] Ruby packages to produce html and pdf output.

1. Install [Ruby][ruby] - on Windows you can use the [RubyInstaller][rubyinstaller] (note that you don't need the Devkit)
2. Run `gem install asciidoctor` to get the main package
3. Run `gem install asciidoctor-pdf` to get the PDF output package

### Further reading

- [AsciiDoc Writer’s Guide](https://asciidoctor.org/docs/asciidoc-writers-guide/)
- [Asciidoctor User Manual](https://asciidoctor.org/docs/user-manual/)
- [Asciidoctor PDF](https://github.com/asciidoctor/asciidoctor-pdf)
- [Asciidoctor PDF Theming Guide](https://github.com/asciidoctor/asciidoctor-pdf/blob/master/docs/theming-guide.adoc) 

  [asciidoc]: http://asciidoc.org/
  [asciidoctor]: https://asciidoctor.org/
  [ruby]: https://www.ruby-lang.org/en/
  [rubyinstaller]: https://rubyinstaller.org/
