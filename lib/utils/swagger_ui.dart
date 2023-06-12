import 'dart:async';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:zero/zero.dart';

enum DocExpansion {
  list,

  full,

  none,
}

enum SyntaxHighlightTheme {
  agate('agate'),
  arta('arta'),
  monokai('monokai'),
  nord('nord'),
  obsidian('obsidian'),
  tomorrowNight('tomorrow-night');

  final String theme;
  const SyntaxHighlightTheme(this.theme);
}


class SwaggerUI {
  ///Schema path (YAML/JSON).
  final String fileSchemaPath;

  ///Defines the title that is visible in the browser tab.
  final String title;

  /// Controls the default expansion setting for the operations and tags.
  final DocExpansion docExpansion;

  ///(Default false) enables the use of deep-links to reference each node in the url (ex: /swagger/#/post).
  final bool deepLink;

  /// Highlight.js syntax coloring theme to use. (Only these 6 styles are available).
  final SyntaxHighlightTheme syntaxHighlightTheme;

  /// If set to true, it persists authorization data and it would not be lost on browser close/refresh
  final bool persistAuthorization;

  SwaggerUI(
    this.fileSchemaPath, {
    this.title = 'Swagger',
    this.docExpansion = DocExpansion.list,
    this.syntaxHighlightTheme = SyntaxHighlightTheme.agate,
    this.deepLink = false,
    this.persistAuthorization = false,
  });

  Future<Response> call(Request request) async {
    return Response.ok(
      '''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <meta
    name="description"
    content="SwaggerUI"
  />
  <title>$title</title>
  <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui.css" />
</head>
<body>
<div id="swagger-ui"></div>
<script src="https://unpkg.com/swagger-ui-dist@4.5.0/swagger-ui-bundle.js" crossorigin></script>

<script>
  window.onload = () => {
    window.ui = SwaggerUIBundle({
      dom_id: '#swagger-ui',
      docExpansion: '${docExpansion.name}',
      deepLinking: $deepLink,
      url: "${basename(File(fileSchemaPath).path)}",
      syntaxHighlight: {
        activate: true,
        theme: '${syntaxHighlightTheme.theme}',
      },
      persistAuthorization: $persistAuthorization,
    });
  };
</script>
</body>
</html>
''',
      {
        HttpHeaders.contentTypeHeader:
            ContentType('text', 'html', charset: 'utf-8').toString(),
      },
    );
  }

  String _resolveFilePath(Directory dir, String path) {
    final subs = dir.listSync(recursive: true).whereType<Directory>().toList();
    for (var subDir in subs) {
      var subDirPath =
          subDir.path.replaceFirst('${dir.path}${Platform.pathSeparator}', '');
      final candidate = '$subDirPath/${basename(path)}'.replaceAll('\\', '/');
      if (path.endsWith(candidate)) {
        return '${dir.path}/$candidate'.replaceAll('\\', '/');
      }
    }

    return '${dir.path}/${basename(path)}';
  }
}
