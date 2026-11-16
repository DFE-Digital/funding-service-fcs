export class CheckResult {
    constructor(ServiceName, Details, IsAvailable, SupplementaryInfo) {
        this.ServiceName = ServiceName;
        this.Details = Details;
        this.IsAvailable = IsAvailable;
        this.SupplementaryInfo = SupplementaryInfo;
        this.isDataFresh = false;
    }
    IsDataFresh() {
        return this.isDataFresh;
    }
    DataIsFresh() {
        this.isDataFresh = true;
    }
}
//# sourceMappingURL=check.result.js.map