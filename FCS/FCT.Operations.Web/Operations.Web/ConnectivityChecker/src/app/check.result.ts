export class CheckResult {
  private isDataFresh: boolean = false;
    constructor(
      public ServiceName: string,
      public Details: string,
      public IsAvailable: boolean,
      public SupplementaryInfo: string) { }

      IsDataFresh(){
        return this.isDataFresh;
      }

      DataIsFresh(){
         this.isDataFresh = true;
      }
  }