namespace SFA.FCT.ContractManagementService.Common
{
    public class ContractAmendmentInformation
    {
        public string ContractNumber { get; set; }

        public int VersionNumber { get; set; }

        public int SubVersionNumber { get; set; }

        public string AmendmentType { get; set; }

        public AmendmentType GetAmendmentType()
        {
            switch (AmendmentType)
            {
                case "VARIATION":
                    return Common.AmendmentType.Variation;
                case "NOTIFICATION":
                    return Common.AmendmentType.Notification;
                default:
                    throw new System.ArgumentException($"{nameof(AmendmentType)} was not valid: {AmendmentType}");
            }
        }

        public bool IsValid()
        {
            return !string.IsNullOrEmpty(ContractNumber)
                   && VersionNumber != 0
                   && (AmendmentType == "VARIATION" || AmendmentType == "NOTIFICATION");
        }

        public override string ToString()
        {
            return $"ContractNumber: {ContractNumber}, VersionNumber: {VersionNumber}, SubVersionNumber: {SubVersionNumber}, AmendmentType: {AmendmentType}";
        }
    }
}