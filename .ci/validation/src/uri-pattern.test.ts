/*
 * Copyright 2023-Present The Serverless Workflow Specification Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// RFC 3986 Appendix B URI-reference regex used in schema/workflow.yaml
// for both LiteralUri and LiteralUriTemplate
const URI_REFERENCE_PATTERN =
  /^(([^:/?#]+):)?(\/\/([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?/;

describe("LiteralUri pattern (RFC 3986 URI-reference)", () => {
  const absoluteUris = [
    "http://example.com",
    "https://example.com/path",
    "https://example.com/path?query=1",
    "https://example.com/path#fragment",
    "https://example.com/path?query=1#fragment",
    "https://user:pass@example.com:8080/path",
    "ftp://files.example.com/public",
    "grpc://localhost:50051",
    "file:///etc/hosts",
    "custom-scheme://authority/path",
  ];

  const relativePathUris = [
    "openapi/petstore.json",
    "proto/greeter.proto",
    "schemas/user.yaml",
    "docs/api.json",
    "../parent/file.json",
    "./sibling/file.yaml",
    "file.json",
  ];

  const absolutePathUris = [
    "/api/v1/users",
    "/openapi/petstore.json",
    "/proto/greeter.proto",
  ];

  const urisWithQueryFragment = [
    "openapi/petstore.json?version=3",
    "/api/docs#section",
    "resource?key=value&other=1",
    "path/to/resource#anchor",
  ];

  const networkPathUris = ["//example.com/path", "//localhost:8080/api"];

  test.each(absoluteUris)("accepts absolute URI: %s", (uri) => {
    expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
  });

  test.each(relativePathUris)("accepts relative path URI: %s", (uri) => {
    expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
  });

  test.each(absolutePathUris)("accepts absolute-path URI: %s", (uri) => {
    expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
  });

  test.each(urisWithQueryFragment)(
    "accepts URI with query/fragment: %s",
    (uri) => {
      expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
    }
  );

  test.each(networkPathUris)("accepts network-path URI: %s", (uri) => {
    expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
  });
});

describe("LiteralUriTemplate pattern (RFC 3986 URI-reference)", () => {
  const absoluteTemplates = [
    "http://example.com",
    "https://example.com/path/{id}",
    "https://server.com/{path}",
    "https://api.example.com/v1/{resource}?limit={limit}",
    "ftp://files.example.com",
    "grpc://localhost:50051",
    "custom-scheme://authority/path",
  ];

  const relativeTemplates = [
    "openapi/{version}/petstore.json",
    "{basePath}/resource",
    "proto/greeter.proto",
    "../{parent}/file.json",
    "/api/{version}/users",
    "docs/{file}.json",
  ];

  test.each(absoluteTemplates)(
    "accepts absolute URI template: %s",
    (uri) => {
      expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
    }
  );

  test.each(relativeTemplates)(
    "accepts relative URI template: %s",
    (uri) => {
      expect(URI_REFERENCE_PATTERN.test(uri)).toBe(true);
    }
  );
});
