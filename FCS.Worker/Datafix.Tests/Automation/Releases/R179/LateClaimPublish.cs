using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Datafix.Tests.Repositories;
using Datafix.Tests.Services;
//using Dtos;
//using Moq;
using Newtonsoft.Json;
using NServiceBus;
using PerformanceManagementDomain.Infrastructure;
using PerformanceManagementDomain.PullFundingClaim.DTOs;
using PerformanceManagementDomain.PullFundingClaim.Extensions;
using PerformanceManagementDomain.PullFundingClaim.Repositories;
using PerformanceManagementDomain.PullFundingClaim.Services;
using PerformanceManagementDomain.Services;
//using Services;
using SFA.FCT.CrossDomain.Integration.Entities.Data;
using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim;
using SFA.FCT.CrossDomain.Integration.Events;
using ClaimReconciliationAllocationGroupFspRepository = PerformanceManagementDomain.ReconciliationCalculationEndpoint.Repositories.ClaimReconciliationAllocationGroupFspRepository;


namespace Datafix.Tests.Automation.Releases.R179
{
    internal class LateClaimPublish : IApplyDataFix
    {
        public string Release => "R179";

        public int StoryNumber => 48132;

        public string Name => "Pull late Funding Claims into Fcs on Period Claim Type";

        public int Order => 1;

        public void ApplyDataFix()
        { 
            string jsonResource = "Resources.R179.MissedReconcillationData.json";
            var fundingClaimApiDto = FromJsonMessageList<FundingClaimApiDto>("Datafix.Tests", jsonResource);
            // persist in DB.
            RemoveInvalidAllocations(fundingClaimApiDto);
            AddRowsToDb(fundingClaimApiDto);

            // now publish
            List<FundingClaim> fundingClaimSchemaObjectsNotInDb = fundingClaimApiDto
                .Select(ConvertFundingClaimDtoToSchemaType).ToList();
            DebatchAndPublishIntoSystem(fundingClaimSchemaObjectsNotInDb);
        }
        private static List<T> FromJsonMessageList<T>(string nameSpace, string resourceName)
        {
            using (Stream stream = Assembly.GetCallingAssembly().GetManifestResourceStream($"{nameSpace}.{resourceName}"))
            using (StreamReader streamReader = new StreamReader(stream))
            {
                return JsonConvert.DeserializeObject<List<T>>(streamReader.ReadToEnd());
            }
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
