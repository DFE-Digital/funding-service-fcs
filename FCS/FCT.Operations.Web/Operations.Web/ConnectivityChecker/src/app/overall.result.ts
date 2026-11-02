import { CheckResult } from './check.result';
export class OverallResult {
    constructor(
      public CheckResults: Array<CheckResult>
     ) { }
  }