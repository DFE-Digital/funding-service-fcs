namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class UpdateExistingPeriodClaimTypeCommand
    {
        public UpdateExistingPeriodClaimTypeCommand(string periodClaimType)
        {
            PeriodClaimType = periodClaimType;
        }

        public string PeriodClaimType { get; }

        public override string ToString() => $"PeriodClaimType:{PeriodClaimType}";
    }
}
