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

import fs from "node:fs";
import Ajv from "ajv/dist/2020";
import addFormats from "ajv-formats";
import path from "node:path";
import yaml = require("js-yaml");

export module SWSchemaValidator {
  const ajv = new Ajv({ strict: false, allowUnionTypes: true });
  addFormats(ajv);

  const workflowSchemaId = "https://open-workflow-specification.org/schemas/1.0.3/workflow.yaml";
  const schemaPath = "../../../schema";
  export const defaultEncoding = "utf-8";

  export function prepareSchemas() {
    const files = fs.readdirSync(path.join(__dirname, schemaPath), {
      encoding: defaultEncoding,
      recursive: false,
      withFileTypes: true,
    });

    files
      .filter((file) => file.isFile())
      .forEach((file) => {
        ajv.addSchema(syncReadSchema(file.name));
      });
  }

  function syncReadSchema(filename: string): any {
    return loadAsJSON(path.join(__dirname, `${schemaPath}/${filename}`));
  }

  export function loadAsJSON(filename: string): any {
    return yamlToJSON(fs.readFileSync(filename, defaultEncoding));
  }

  export function yamlToJSON(yamlStr: string): any {
    const yamlObj = yaml.load(yamlStr, {
      json: true,
    });
    return structuredClone(yamlObj);
  }

  export function validateSchema(workflow: Record<string, unknown>) {
    const validate = ajv.getSchema(workflowSchemaId);

    if (!validate) {
      throw new Error(`Unable to find schema with id '${workflowSchemaId }'`);
    }

    const isValid = validate(workflow);
    return {
      valid: isValid,
      errors: validate.errors,
    };
  }
}

console.log("To use this application see the test file index.test.ts");
