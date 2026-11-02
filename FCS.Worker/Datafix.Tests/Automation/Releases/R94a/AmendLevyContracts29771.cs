namespace Datafix.Tests.Automation.Releases.R94a
{
    using System.Collections.Generic;
    using System.Linq;
    using Datafix.Tests.Repositories;
    using NServiceBus;
    using Services;
    using SFA.FCT.ContractManagementService.Common.Commands;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public class AmendLevyContracts29771 : IApplyDataFix
    {
        private static readonly IReadOnlyCollection<int> UkprnsToAmendViaSingle = new List<int>
            {
                10044749,        // THE BUSINESS PORTFOLIO (UK) LIMITED
                10024415,        // KEYSTONE TRAINING LTD 
                10029974,        // RITA'S TRAINING SERVICES
                10027935,        // PROSPECTS TRAINING INTERNATIONAL LIMITED
                10008947,        // MANATEC LIMITED
                10034315,        // LIGA (UK) LTD
                10003717,        // KPMG LLP
                10001041,        // GLOUCESTERSHIRE ENTERPRISE LIMITED
                10038872,        // GENIUS SOFTWARE SOLUTIONS LIMITED
                10034001,        // ASHLEY HUNTER LTD
                10084572,        // BROWNS STAMFORD LTD
                10007091,        // TWIN TRAINING INTERNATIONAL LIMITED
                10019210,        // ENTERKEY TRAINING LIMITED
                10044705,        // ASTRO MARTIN LTD
                10047028,        // VERITY HEALTHCARE LIMITED
                10085310,        // BRAILLARD TRAINING LIMITED
                10084678,        // CHILDBASE PARTNERSHIP LIMITED
                10082851,        // CONVEY365 LTD
                10005835,        // SIEMENS INDUSTRIAL TURBOMACHINERY LIMITED
                10085193,        // POTENTIAL REALISED - HR & TRAINING LIMITED
                10085356,        // SIEMENS MOBILITY LIMITED
                10085048,        // OPEN HEART CARE LTD 
                10083267,        // COMPASS SKILLS TRAINING LIMITED
                10026921,        // CHRIST THE REDEEMER COLLEGE
                10085923,        // 4C SOLUTIONS LTD
                10064349,        // APEX SKILL TRAINING LTD
                10034011,        // EXCELL FOR TRAINING LIMITED
                10021254,        // JFC  TRAINING COLLEGE LTD
                10047908,        // SOUTH WEST CONSTRUCTION ACADEMY LIMITED
                10033154,        // TRAIN WITH PRIDE LIMITED
                10058066,        // FAIRCROFT & MEADOWS CONSULTANCY LTD
                10085631,        // EYC GLOBAL LIMITED
                10083323,        // G & R ASSOCIATES LIMITED
                10063293,        // HAGLEYS GROUP LIMITED
                10032624,        // LUTON INTERNATIONAL COLLEGE LIMITED
                10082565,        // MARY P'S LTD
                10065702,        // MYBE AWARDS LTD
                10081713,        // MULTI TRADES TRAINING LTD
                10084975,        // MINDFLEX PSYCHOLOGY LIMITED
                10054006,        // QUALIA AESTHETICS LIMITED
                10047426,        // SHE COMPLIANCY LIMITED
                10063536,        // THE WELDING ACADEMY LIMITED
                10065571,        // UNIVERSAL VIBES LIMITED
                10085877,        // THE ENGAGEMENT COACH LIMITED
                10061637,        // VMZONE LTD
                10085751,        // THE SPECIALISTS HUB LTD
                10005886,        // SKERN LODGE LIMITED
                10066420,        // GEOSEIS CONSULTANT LIMITED
                10041086,        // DMR TRAINING & CONSULTANCY LIMITED
                10031131,        // ALTHAUS DIGITAL LIMITED
                10085478,        // LEX HYGIENE LTD
            };
        public string Release => "R94a";

        public int StoryNumber => 29771;

        public string Name => "Publish Spring 2020 v2.0 version of Apprenticeships Provider Agrmt [24-AUG]";

        public int Order => 1;

        public void ApplyDataFix()
        {
            const string levyFundingType = "LEVY";
            const string levyFundingPeriod = "LEVY1799";
            
            IEndpointInstance endpoint = EndpointBuilder.CreateSendOnlyEndpoint<AmendLevyContractCommand>();
            CrmContractInformationRepository crmRepository = new CrmContractInformationRepository();
            IReadOnlyCollection<ContractInformation> allLevyContracts =
                crmRepository.GetLatestContractInformationByFundingTypeAndFundingPeriod(levyFundingType, levyFundingPeriod);

            SendBulkLevyAmendments(endpoint, allLevyContracts);

            SendSingleLevyAmendments(endpoint, allLevyContracts);
        }

        private static void SendBulkLevyAmendments(IEndpointInstance endpoint, IReadOnlyCollection<ContractInformation> allLevyContracts)
        {
            const int newAgreementsContractNumberThreshold = 5000;

            bool IsNewAgreementAndNotForSingle(ContractInformation c)
            {
                return c.NumberPartOfContractNumber >= newAgreementsContractNumberThreshold &&
                       !UkprnsToAmendViaSingle.Contains(int.Parse(c.Ukprn));
            }

            allLevyContracts
                .Where(IsNewAgreementAndNotForSingle)
                .ToList()
                .ForEach(c =>
                {
                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = SFA.FCT.ContractManagementService.Common.AmendmentType.Variation,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Bulk,
                        ShouldAddPayableNonLevyAllocation = false,
                        AllowUnderTermination = false
                    }).Wait();
                });
        }

        private static void SendSingleLevyAmendments(IEndpointInstance endpoint, IReadOnlyCollection<ContractInformation> allLevyContracts)
        {
            bool IsInSingleList(ContractInformation c)
            {
                return UkprnsToAmendViaSingle.Contains(int.Parse(c.Ukprn));
            }

            allLevyContracts
                .Where(IsInSingleList)
                .ToList()
                .ForEach(c =>
                {
                    endpoint.Send("ContractManagementDomain.LevyAmendmentEndpoint", new AmendLevyContractCommand
                    {
                        ContractInformation = c,
                        AmendmentType = SFA.FCT.ContractManagementService.Common.AmendmentType.Variation,
                        AmendmentSource = AmendLevyContractCommand.LevyAmendmentSource.Single,
                        ShouldAddPayableNonLevyAllocation = false,
                        AllowUnderTermination = false
                    }).Wait();
                });
        }
    }
}
