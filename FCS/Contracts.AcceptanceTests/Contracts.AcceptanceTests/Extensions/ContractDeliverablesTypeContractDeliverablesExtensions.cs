
namespace SFA.FCT.Contracts.AcceptanceTests.Extensions
{
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public static class ContractDeliverablesTypeContractDeliverablesExtensions
    {
        public static List<contractDeliverablesTypeContractDeliverable> ToFlattenedList(this List<contractDeliverablesTypeContractDeliverable> corpSchemaDeliverables)
        {
            return FlattenDeliverables(corpSchemaDeliverables);
        }

        public static List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable> FlattenDeliverables(
            List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable> hierarchicalDeliverableList,
            List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable> flattenedList = null)
        {
            flattenedList = flattenedList ?? new List<SFA.FCT.CrossDomain.Integration.Entities.CorporateSchema.Contract.contractDeliverablesTypeContractDeliverable>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);

                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList);
            }

            return flattenedList;
        }

    }
}
