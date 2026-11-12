/*
 * Copyright 2023-Present The Open Workflow Specification Authors
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

import { SWSchemaValidator } from "./index";
import fs from "node:fs";
import path from "node:path";
import marked from "marked";

SWSchemaValidator.prepareSchemas();

const dslReferencePath = path.join(
  __dirname,
  "..",
  "..",
  "..",
  "dsl-reference.md"
);

describe(`Verify every example in the dsl docs`, () => {
  const workflows = marked
    .lexer(fs.readFileSync(dslReferencePath, SWSchemaValidator.defaultEncoding))
    .filter((item): item is marked.Tokens.Code => item.type === "code")
    .filter((item) => item.lang === "yaml")
    .map((item) => item.text)
    .map((text) => SWSchemaValidator.yamlToJSON(text))
    .filter((workflow) => typeof workflow === "object")
    .filter((workflow) => "document" in workflow)
    .filter((workflow) => "dsl" in workflow.document);

  test.each(workflows)("$document.name", (workflow) => {
    const results = SWSchemaValidator.validateSchema(workflow);
    if (results?.errors) {
      console.warn(
        `Schema validation on workflow ${workflow.document.name} failed with: `,
        JSON.stringify(results.errors, null, 2)
      );
    }
    expect(results?.valid).toBeTruthy();
  });
});
