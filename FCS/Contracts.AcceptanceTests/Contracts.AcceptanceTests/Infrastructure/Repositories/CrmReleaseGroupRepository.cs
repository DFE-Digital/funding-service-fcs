namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.Repositories
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Xrm;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;
    using DTO;
    using Microsoft.Xrm.Sdk;
    using Services;

    public static class CrmReleaseGroupRepository
    {
        public static void DeleteReleaseGroupAndFundingAllocationsByBusinessKey(string fundingTypeCode, string fundingPeriod, string fspGroupCode, string contractType)
        {
            var organizationService = CrmConnectionFactory.GetConnection();

            using (var context = new XrmServiceContext(organizationService))
            {
                var releaseGroupIds = (
                    from rg in context.sfa_releasegroupSet
                     join ft in context.sfa_fundingtypeSet on rg.sfa_fundingtype.Id equals ft.Id
                     join fp in context.sfa_periodSet on rg.sfa_fundingperiod.Id equals fp.Id
                     join fspGroup in context.sfa_fspgroupSet on rg.sfa_fspgroup.Id equals fspGroup.Id
                     join ct in context.sfa_contracttypeSet on rg.sfa_contracttype.Id equals ct.Id
                     where
                        ft.sfa_fundingtypecode == fundingTypeCode &&
                        fp.sfa_periodname == fundingPeriod &&
                        fspGroup.sfa_name == fspGroupCode &&
                        ct.sfa_name == contractType
                     select rg.Id
                    ).ToList();


                releaseGroupIds.ForEach(releaseGroupId =>
                {
                    var fundingAllocationIds = (
                        from fa in context.sfa_fundingallocationSet
                        where fa.sfa_releasegroup.Id == releaseGroupId
                        select fa.Id
                        ).ToList();

                    fundingAllocationIds.ForEach(fundingAllocationId => organizationService.Delete(sfa_fundingallocation.EntityLogicalName, fundingAllocationId));

                    organizationService.Delete(sfa_releasegroup.EntityLogicalName, releaseGroupId);
                });
            }
        }

        public static bool ReleaseCollectionOfReleaseGroups(IEnumerable<Guid> releaseGroupIds)
        {
            var organizationRequest = new OrganizationRequest("sfa_FundingAllocationRelease")
            {
                Parameters =
                {
                    ["inputIDs"] = string.Join(";", releaseGroupIds)
                }
            };

           var response = CrmConnectionFactory.GetConnection().Execute(organizationRequest);

           return response.Results.Single().Value.ToString() == "Accepted";
        }

        public static string GetNameOfAwaitingReleaseGroupByBusinessKeyOrDefault(string fundingTypeCode, string fundingPeriod, string fspGroupCode, string contractType)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return (
                    from rg in context.sfa_releasegroupSet
                    join ft in context.sfa_fundingtypeSet on rg.sfa_fundingtype.Id equals ft.Id
                    join fp in context.sfa_periodSet on rg.sfa_fundingperiod.Id equals fp.Id
                    join fspGroup in context.sfa_fspgroupSet on rg.sfa_fspgroup.Id equals fspGroup.Id
                    join ct in context.sfa_contracttypeSet on rg.sfa_contracttype.Id equals ct.Id
                    where
                        ft.sfa_fundingtypecode == fundingTypeCode &&
                        fp.sfa_periodname == fundingPeriod &&
                        fspGroup.sfa_name == fspGroupCode &&
                        ct.sfa_name == contractType &&
                        rg.sfa_releasestatus.Value == (int)sfa_ReleaseGroupStatus.AwaitingRelease
                    select rg.sfa_name
                    ).SingleOrDefault();
            }
        }

        public static ReleaseGroupInfo GetInfoByName(string releaseGroupName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                var releaseGroup = (
                    from rg in context.sfa_releasegroupSet
                    where rg.sfa_name == releaseGroupName
                    select new
                    {
                        rg.Id,
                        Name = rg.sfa_name,
                        Status = (sfa_ReleaseGroupStatus)rg.sfa_releasestatus.Value,
                        Count = rg.sfa_associatedcount
                    })
                    .Single();

                var fundingAllocations = (
                    from fa in context.sfa_fundingallocationSet
                    where fa.sfa_releasegroup.Id == releaseGroup.Id
                    select new
                    {
                        fa.sfa_value.Value
                    }
                ).ToList();

                return new ReleaseGroupInfo
                {
                    Name = releaseGroup.Name,
                    Status = releaseGroup.Status,
                    FundingAllocationCount = releaseGroup.Count??0,
                    FundingAllocationValue = fundingAllocations.Sum(fa => fa.Value)
                };
            }
        }

        public static Guid GetIdByName(string releaseGroupName)
        {
            using (var context = new XrmServiceContext(CrmConnectionFactory.GetConnection()))
            {
                return context.sfa_releasegroupSet
                    .Where(rg => rg.sfa_name == releaseGroupName)
                    .Select(rg => rg.sfa_releasegroupId.Value)
                    .Single();
            }
        }
    }
}
