namespace Datafix.Tests.Automation.Releases.R108b
{
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.SqlClient;
    using System.Linq;
    using NServiceBus;
    using PerformanceManagementDomain.Infrastructure;
    using PerformanceManagementDomain.PullFundingClaim.DTOs;
    using PerformanceManagementDomain.PullFundingClaim.Extensions;
    using PerformanceManagementDomain.PullFundingClaim.Repositories;
    using PerformanceManagementDomain.PullFundingClaim.Services;
    using PerformanceManagementDomain.Services;
    using Services;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;
    using ClaimReconciliationAllocationGroupFspRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupFspRepository;

    public class LateFundingClaimDataFix : IApplyDataFix
    {
        public string Release => "R108b";

        public int StoryNumber => 35698;

        public string Name => "Pull late Funding Claims into Fcs on Period Claim Type";

        public int Order => 1;

        public void ApplyDataFix()
        {
            const string periodClaimType = "2021-Final";
            var endpoint = EndpointBuilder.CreateSendOnlyEndpoint<UpdateExistingPeriodClaimTypeCommand>();
            endpoint.Send("PerformanceManagementDomain.PullFundingClaim",
                new UpdateExistingPeriodClaimTypeCommand(periodClaimType)).Wait();
        }

        private IFundingClaimsApiAdapter GetAdapter()
        {
            return new FundingClaimsApiAdapter(new HttpService(), new OAuthAccessTokenFactory());
            //Mock<IFundingClaimsApiAdapter> adapterMock = new Mock<IFundingClaimsApiAdapter>();
            //adapterMock.Setup(a => a.GetCountOfFundingClaimsForCollectionKey(It.IsAny<string>())).ReturnsAsync(1);
            //adapterMock.SetupGet(a => a.PageSize).Returns(10);
            //adapterMock.Setup(a => a.GetFundingClaimsForCollectionKey(It.IsAny<string>(), It.IsAny<int>())).Returns( (string s, int pa)
            //     =>
            //    {
            //        return Task.FromResult((IReadOnlyCollection<FundingClaimApiDto>)new List<FundingClaimApiDto>
            //        {
            //            new FundingClaimApiDto
            //            {
            //                ClaimTypeName = "YEAREND",
            //                Period = "2021",
            //                PeriodTypeCode = "AY",
            //                VersionNumber = 1,
            //                OrganisationIdentifier = "ORG1"
            //            }
            //        });
            //    });

            //return adapterMock.Object;
        }

        private void RemoveInvalidAllocations(IReadOnlyCollection<FundingClaimApiDto> fundingClaimSchemaObjectsNotInDb)
        {
            var validFspCodes = GetValidFsps();

            fundingClaimSchemaObjectsNotInDb
                .ToList()
                .ForEach(fc => fc.ContractAllocations = fc.ContractAllocations.Where(ca => validFspCodes.Contains(ca.FundingStreamPeriodCode)).ToList());
        }

        private void AddRowsToDb(IReadOnlyCollection<FundingClaimApiDto> fundingClaimSchemaObjectsNotInDb)
        {
            PerformanceManagementDomain.PullFundingClaim.Repositories.FundingClaimRepository fundingClaimRepository = new FundingClaimRepository();
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnection(connectionString))
            {
                var fundingClaims = fundingClaimSchemaObjectsNotInDb
                    .Select(dto => dto.ToDataModel()).ToList();
                
                fundingClaimRepository
                    .AddFundingClaims(fundingClaims, new ConnectionInfo(null, connection)).Wait();
            }
        }

        private IReadOnlyCollection<string> GetValidFsps()
        {
            PerformanceManagementDomain.PullFundingClaim.Repositories.ClaimReconciliationAllocationGroupFspRepository fspRepository = new PerformanceManagementDomain.PullFundingClaim.Repositories.ClaimReconciliationAllocationGroupFspRepository();
            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;
            using (var connection = new SqlConnection(connectionString))
            {
                return fspRepository.GetValidFundingStreamPeriodCodes(new ConnectionInfo(null, connection)).Result;
            }
        }

        private void DebatchAndPublishIntoSystem(IReadOnlyCollection<FundingClaim> fundingClaimSchemaObjectsNotInDb)
        {
            IFundingClaimDebatchService fundingClaimDebatchService = new FundingClaimDebatchService(new ClaimReconciliationAllocationGroupFspRepository());

            string connectionString = ConfigurationManager.ConnectionStrings["ContractManagementDbContext"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                var allDebatchedFundingClaims = fundingClaimSchemaObjectsNotInDb
                    .Select(fc => fundingClaimDebatchService.DebatchFundingClaimByAllocationGroup(fc, new ConnectionInfo(null, connection)).Result.ToList())
                    .ToList();

                var endpoint = EndpointBuilder.CreatePublishingEndpoint<FundingClaimDebatchedEvent>("PerformanceManagementDomain.FundingClaimImport");
                foreach (var debatchedFundingClaimCollection in allDebatchedFundingClaims)
                {
                    PublishDebatchedFundingClaims(debatchedFundingClaimCollection, endpoint);
                }
            }
        }

        private void PublishDebatchedFundingClaims(IEnumerable<DebatchedFundingClaim> debatchedFundingClaims, EndpointBuilder endpoint)
        {
            foreach (DebatchedFundingClaim fc in debatchedFundingClaims)
            {
                endpoint.Publish<FundingClaimDebatchedEvent>(x =>
                {
                    x.DebatchedFundingClaim = fc;
                }).Wait();
            };
        }

        private static SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim ConvertFundingClaimDtoToSchemaType(FundingClaimApiDto fundingClaim)
        {
            return new SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim.FundingClaim
            {
                Period = fundingClaim.Period,
                ClaimTypeName = (ClaimTypeName)Enum.Parse(typeof(ClaimTypeName), fundingClaim.ClaimTypeName.Replace(" ", string.Empty).ToUpper()),
                ContractAllocations = fundingClaim.ContractAllocations.Select(ConvertAllocationToDto).ToList(),
                HasBeenSigned = bool.Parse(fundingClaim.HasBeenSigned.ToUpper()),
                PeriodTypeCode = (PeriodTypeCode)Enum.Parse(typeof(PeriodTypeCode), fundingClaim.PeriodTypeCode),
                Contractor = new Contractor { OrganisationIdentifier = fundingClaim.OrganisationIdentifier, Ukprn = int.Parse(fundingClaim.Ukprn) },
                VersionNumber = fundingClaim.VersionNumber
            };
        }

        private static ContractAllocation ConvertAllocationToDto(ContractAllocationApiDto allocation)
        {
            return new ContractAllocation
            {
                ContractAllocationNumber = allocation.ContractAllocationNumber,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                DeliverableLines = allocation.DeliverableCodes.Select(ConvertDeliverableToDto).ToList()
            };
        }

        private static DeliverableLine ConvertDeliverableToDto(DeliverableCodeApiDto deliverable)
        {
            return new DeliverableLine
            {
                DeliverableCode = deliverable.DeliverableCodeValue,
                ActualValue = deliverable.ActualValue,
                AdjustmentValue = deliverable.AdjustmentValue,
                ForecastValue = deliverable.ForecastValue,
                TotalDelivery = deliverable.TotalDelivery
            };
        }
    }
}
