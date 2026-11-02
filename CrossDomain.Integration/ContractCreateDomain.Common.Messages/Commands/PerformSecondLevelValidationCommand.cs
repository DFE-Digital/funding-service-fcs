namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities;

    public class PerformSecondLevelValidationCommand
    {
        public contractRequestType ContractRequest { get; set; }

        public IEnumerable<string> ContractTypes { get; set; }

        public IEnumerable<string> LepCodes { get; set; }

        public IEnumerable<string> UopCodes { get; set; }
        
        public IDictionary<string, FSCDeliverableStructureDefinitionResponse> DeliverableStructures { get; set; }
    }
}
