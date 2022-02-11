Intl_generator
====

This is a fork of intl_translation to have an up to date version.

If you prefer having translations as part of your build_runner process or need to support flavors, please check [intl_flavors](https://pub.dev/packages/intl_flavors)

This package provides message extraction and code generation from translated
messages for the [Intl][Intl] package. It's a separate package so as to not
require a dependency on analyzer for all users.

## Extracting And Using Translated Messages

When your program contains messages that need translation, these must
be extracted from the program source, sent to human translators, and the
results need to be incorporated.

To extract messages, run the `extract_to_arb.dart` program.

      pub run intl_generator:extract_to_arb --output-dir=target/directory
          my_program.dart more_of_my_program.dart my/target/programs/directory

This will produce a file `intl_messages.arb` with the messages from all of these
programs. This is an [ARB][ARB] format file which can be used for input to
translation tools like [Localizely][Localizely] or (the deprecated) [Google
Translator Toolkit](https://translate.google.com/toolkit/). The resulting
translations can be used to generate a set of libraries using the
`generate_from_arb.dart` program.

This expects to receive a series of files, one per
locale.

```
pub run intl_generator:generate_from_arb --generated-file-prefix=<prefix>
    <my_dart_files> <my_dart_files_directory> <translated_ARB_files>
```

This will generate Dart libraries, one per locale, which contain the
translated versions. Your Dart libraries can import the primary file,
named `<prefix>messages_all.dart`, and then call the initialization
for a specific locale. Once that's done, any
[Intl.message][Intl.message] calls made in the context of that locale
will automatically print the translated version instead of the
original.

    import "my_prefix_messages_all.dart";
    ...
    initializeMessages("dk").then(printSomeMessages);

Once the Future returned from the initialization call completes, the
message data is available.

[Intl]: https://www.dartdocs.org/documentation/intl/latest
[Intl.message]: https://www.dartdocs.org/documentation/intl/latest/intl/Intl/message.html
[ARB]: https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification
[Localizely]: https://localizely.com/
