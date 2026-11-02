
namespace SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation
{
    using System.Collections.Generic;
    using System.Linq;

    public partial class allocationType
    {
        public List<contractDeliverableType> FlattenDeliverables(
            List<contractDeliverableType> hierarchicalDeliverableList,
            List<contractDeliverableType> flattenedList = null, int? parentDeliverablId = null)
        {
            flattenedList = flattenedList ?? new List<contractDeliverableType>();

            foreach (var deliverable in hierarchicalDeliverableList)
            {
                flattenedList.Add(deliverable);
                //// check null if you must
                flattenedList = FlattenDeliverables(deliverable.contractDeliverables, flattenedList,
                    deliverable.deliverable.deliverableCode);
            }

            return flattenedList;
        }

        public string GetFspCode()
        {
            return fundingStreamPeriod.fundingStreamPeriodCode;
        }

        public override string ToString()
        {
            return
                $"Allocation Number: {this.contractAllocationNumber}, version: {this.contractReference?.contractVersionNumber}";
        }
    }

    public partial class organisationReferenceType
    {
        public int GetUkprn()
        {
            string ukprn =
                alternativeOrganisationIdentifiers
                    .Single(altId => altId.OrganisationIdentifierName == alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER)
                    .OrganisationIdentifier;

            return int.Parse(ukprn);
        }
    }
}
