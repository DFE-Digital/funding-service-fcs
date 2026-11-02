namespace FundingAllocation.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using Dto;
    using Newtonsoft.Json.Linq;
    using SFA.FCT.CrossDomain.Integration.Messages.FundingAllocation.Dtos;

    public static class CfsAtomParser
    {
        public static string GetPrevLink(string json)
        {
            JObject jObject = JObject.Parse(json);
            var linkJToken = jObject["link"];

            var links = linkJToken.Select(l => new {Href = l["href"], Rel = l["rel"]}).ToList();
            var prevLink = links.FirstOrDefault(l => l.Rel.ToString() == "prev-archive")?.Href?.ToString();

            return prevLink;
        }

        public static int GetPageNumberFromLink(string atomUrl)
        {
            int lastIndexOfSlash = atomUrl.LastIndexOf('/');
            string afterSlashPart = atomUrl.Substring(lastIndexOfSlash + 1);

            return int.Parse(afterSlashPart.Split('?')[0]);
        }

        public static IReadOnlyCollection<AtomItem> GetAtomItems(string json)
        {
            JObject jObject = JObject.Parse(json);
            var atomEntryToken = jObject["atomEntry"];
            var atomItems = atomEntryToken.Select((item, i) =>
            {
                var fundingJToken = item["content"]["funding"];
                var providerFundingJArray = (JArray) fundingJToken["providerFundings"];
                var providerFundingIds = providerFundingJArray.Select(pf => pf.ToString()).ToArray();

                return new AtomItem
                {
                    FundingId = fundingJToken["id"].ToString(),
                    FundingVersion = fundingJToken["fundingVersion"].ToString(),
                    Period = fundingJToken["fundingPeriod"]["id"].ToString(),
                    AllocationFundingStream = fundingJToken["fundingStream"]["code"].ToString(),
                    Ukprn = fundingJToken["organisationGroup"]["groupTypeIdentifier"]["value"].ToString(),
                    Value = decimal.Parse(fundingJToken["fundingValue"]["totalValue"].ToString()),
                    PositionInPage = i + 1,
                    ProviderFundingIds = providerFundingIds
                };
            }).ToList();

            return atomItems;
        }

        public static ProviderFundingAllocationApiDto GetProviderFundingAllocationApiDto(string json)
        {
            JObject jObject = JObject.Parse(json);
            var providerJToken = jObject["provider"];
                        
            return new ProviderFundingAllocationApiDto
            {
                ProviderFundingId = jObject["id"].ToString(),
                ProviderType = providerJToken["providerType"].ToString(),
                ProviderSubType = providerJToken["providerSubType"].ToString(),
                DeliveryUkprn = int.Parse(providerJToken["identifier"].ToString()),
                FundingAllocationLines =
                    jObject["fundingValue"]["fundingLines"].Select(fl =>
                        new FundingAllocationLineApiDto
                        {
                            FundingLineCode = fl["fundingLineCode"].ToString(),
                            Type = fl["type"].ToString(),
                            Value = fl["value"].ToString(),
                            FundingAllocationProfilePeriods = TransformToFundingAllocationProfilePeriods(fl["distributionPeriods"])
                        }).ToArray()
            };            
        }

        private static FundingAllocationProfilePeriodApiDto[] TransformToFundingAllocationProfilePeriods(
            JToken distributionPeriodsJToken)
        {
            var profilePeriodsJTokens = distributionPeriodsJToken.Select(dp => new {ProfilePeriods = dp["profilePeriods"]}).ToList();

            var profilePeriods = profilePeriodsJTokens.SelectMany(profilePeriodsJToken =>
            {
                return profilePeriodsJToken.ProfilePeriods.Select(pp => new FundingAllocationProfilePeriodApiDto
                {
                    Year = int.Parse(pp["year"].ToString()),
                    Month = pp["typeValue"].ToString(),
                    PlannedValue = decimal.Parse(pp["profiledValue"].ToString())
                });
            }).ToArray();

            return profilePeriods;
        }
    }
}
