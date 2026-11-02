namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Test.Utils
{
    using System;
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities.DeliveryAllocation;

    public class TestAllocation
    {
        public static allocationType Create(string fspcode = "FSPC1")
        {
            var newAllocation = new allocationType
            {
                contractAllocationNumber = "SFA-123",
                description = "description",
                lastModifiedContractVersion = "1",
                lastModifiedDate = 0,
                maximumContractValue = 1M,
                startDate = DateTime.Now,
                endDate = DateTime.Now.AddMonths(1),
                contractDeliverables = new List<contractDeliverableType>{
                    new contractDeliverableType
                    {
                        contractDeliverablePeriods = new List<contractDeliverablePeriodsTypeContractDeliverablePeriod>
                        {
                            new contractDeliverablePeriodsTypeContractDeliverablePeriod
                            {          
                                plannedValue = 0M, 
                                plannedVolume = 0,
                                period = new periodType
                                {
                                    periodType1 = new periodTypeType
                                    {
                                        periodTypeCode = periodTypeCodeType.AY, 
                                        periodTypeName = periodTypeNameType.ACADEMICYEAR
                                    },
                                    periodValue = "201501",
                                }
                            },
                        }, 
                        deliverable = new deliverableType
                        { 
                            deliverableCode = 1, 
                            deliverableName = "DelName", 
                            isLegal = true, 
                            isMonitoring = false,
                        }, 
                        deliverableDescription = "delDescription", 
                        plannedValue = 100M, 
                        plannedVolume = 10,
                    } 
                },
                contractorReference = new organisationReferenceType
                {
                    organisationIdentifier = "ordID",
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = "10017551", 
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                        }
                    }
                },
                contractReference = new contractReferenceType
                {
                    contractNumber = "sfa-123",
                    contractSubVersionNumber = 1,
                    contractVersionNumber = 2,
                },
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                {
                    endDate = DateTime.Now,
                    fundingStreamPeriodCode = fspcode,
                    period = new periodType
                    {
                        periodType1 = new periodTypeType
                        {
                            periodTypeCode = periodTypeCodeType.AY,
                            periodTypeName = periodTypeNameType.ACADEMICYEAR
                        },
                        periodValue = "201501"
                    },
                    startDate = DateTime.Now,
                },
            };
            return newAllocation;
        }
    }
}
