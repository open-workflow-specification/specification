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

SWSchemaValidator.prepareSchemas();

const examplePath = "../../../examples";

describe(`Verify every example in the repository`, () => {
  const examples = fs
    .readdirSync(path.join(__dirname, examplePath), {
      encoding: SWSchemaValidator.defaultEncoding,
      recursive: false,
      withFileTypes: true,
    })
    .filter((file) => file.isFile())
    .filter((file) => file.name.endsWith(".yaml"))
    .map((file) => file.name);

  test.each(examples)("Example %s", (file) => {
    const workflow = SWSchemaValidator.loadAsJSON(
      path.join(__dirname, `${examplePath}/${file}`)
    );
    const results = SWSchemaValidator.validateSchema(workflow);
    if (results?.errors) {
      console.warn(
        `Schema validation on ${file} failed with: `,
        JSON.stringify(results.errors, null, 2)
      );
    }
    expect(results?.valid).toBeTruthy();
  });
});
