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

const ctkDir = path.join(__dirname, "..", "..", "..", "ctk", "features");

function extractYamlBlocks(content: string): string[] {
    const yamlBlockRegex = /"""yaml\s([\s\S]*?)\s"""/gm;  // Match YAML blocks
    let match;
    const yamlBlocks: string[] = [];

    while ((match = yamlBlockRegex.exec(content)) !== null) {
        yamlBlocks.push(match[1]);
    }

    return yamlBlocks;
}

const workflows = fs.readdirSync(ctkDir)
    .filter((file) => file.endsWith(".feature"))
    .flatMap((file) => {
        const filePath = path.join(ctkDir, file);
        const fileContent = fs.readFileSync(filePath, SWSchemaValidator.defaultEncoding);

        const yamlBlocks = extractYamlBlocks(fileContent);

        return yamlBlocks
            .map((yamlText) => SWSchemaValidator.yamlToJSON(yamlText))
            .filter((workflow) => typeof workflow === "object")
            .filter((workflow) => "document" in workflow)
            .filter((workflow) => "dsl" in workflow.document)
            .map((workflow) => ({ workflow, file }));
    });

describe(`Validate workflows from .feature files`, () => {
    test.each(workflows)('$workflow.document.name (from $file)', ({ workflow, file }) => {
        const results = SWSchemaValidator.validateSchema(workflow);

        if (results?.errors) {
            console.warn(
                `Schema validation failed for workflow "${workflow.document.name}" in file "${file}" with:`,
                JSON.stringify(results.errors, null, 2)
            );
        }

        expect(results?.valid).toBeTruthy();
    });
});
