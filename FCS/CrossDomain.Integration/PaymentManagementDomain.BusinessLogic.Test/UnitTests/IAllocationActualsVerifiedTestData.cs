using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;
using SFA.FCT.CrossDomain.Integration.Events;


namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Tests.Utils
{
    public class IAllocationActualsVerifiedTestData
    {

        public static IAllocationActualsVerified Create()
        {
            return new AllocationActualsVerified()
            {
                AllocationActuals = new ContractAllocationActualsType()
                {
                    ContractAllocationNumber = "ALLC-1234",
                    FundingStreamPeriodCode = "FspCode",
                    ContractReference =
                        new ContractReferenceType() {ContractNumber = "Main-123", ContractVersionNumber = 1},
                    ActualsSummary = new List<ActualsSummaryType>()
                    {
                        new ActualsSummaryType()
                        {
                            DeliverableCode = 2,
                            Period = "201508",
                            ActualValue = 333,
                            PeriodType = new PeriodTypeType() {PeriodTypeCode = "AY"}
                        },
                        new ActualsSummaryType()
                        {
                            DeliverableCode = 2,
                            Period = "201509",
                            ActualValue = 444,
                            PeriodType = new PeriodTypeType() {PeriodTypeCode = "AY"}
                        },
                            new ActualsSummaryType()
                        {
                            DeliverableCode = 3,
                            Period = "201509",
                            ActualValue = 555,
                            PeriodType = new PeriodTypeType() {PeriodTypeCode = "AY"}
                        }
                    },
                    ContractorReference = new OrganisationReferenceType()
                    {
                        OrganisationIdentifier = "OrgId",
                        AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>()
                        {
                            new organisationIdentifiersOrganisationIdentifier()
                            {
                                organisationIdentifier = "12345678",
                                organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                            }
                        }
                    }
                }
            };
        }
    }
}


                     
