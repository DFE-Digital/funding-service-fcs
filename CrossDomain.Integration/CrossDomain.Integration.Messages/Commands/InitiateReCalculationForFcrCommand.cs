namespace SFA.FCT.CrossDomain.Integration.Messages.Commands
{
    public class InitiateReCalculationForFcrCommand
    {
        public string FcrId { get; set; }

        public string FcrName { get; set; }

        public bool HasFinalReconciliationValueChanged { get; set; }

        public override string ToString()
        {
            return $"FcrName: {FcrName}, HasFinalReconciliationValueChanged: {HasFinalReconciliationValueChanged}, FcrId: {FcrId}";
        }
    }
}
