namespace FundingAllocation.Services
{
    using System;
    using System.Threading.Tasks;
    using Dto;
    using Endpoints.CreateFundingAllocationInCrm;
    using Repositories;

    public class ReleaseGroupService : IReleaseGroupService
    {
        private readonly IReleaseGroupRepository _releaseGroupRepository;
        private readonly ICrmReleaseGroupRepository _crmReleaseGroupRepository;

        public ReleaseGroupService(IReleaseGroupRepository releaseGroupRepository,
            ICrmReleaseGroupRepository crmReleaseGroupRepository)
        {
            _releaseGroupRepository = releaseGroupRepository;
            _crmReleaseGroupRepository = crmReleaseGroupRepository;
        }

        public async Task<ReleaseGroupId> GetOrCreateReleaseGroup(
            string fcsFundingType,
            string fcsPeriod,
            string fspGroupCode,
            string fcsContractType,
            Func<Task<CrmFundingAllocationFks>> getCrmFundingAllocationFKs)
        {
            var optionReleaseGrpId = await _releaseGroupRepository.GetAwaitingReleaseGroup(
                fundingTypeCode: fcsFundingType,
                fundingPeriod: fcsPeriod,
                fspGroupCode: fspGroupCode,
                contractType: fcsContractType);

            var releaseGroupId = await optionReleaseGrpId.MatchAsync(Some: Task.FromResult,
                None: async () =>
                {
                    var crmReleaseGrpId = Guid.NewGuid();
                    string releaseGroupName = await _releaseGroupRepository.GetNextReleaseGroupName();

                    var paasReleaseGrpId = await _releaseGroupRepository.CreateReleaseGroup(
                        fundingTypeCode: fcsFundingType,
                        fundingPeriod: fcsPeriod,
                        fspGroupCode: fspGroupCode,
                        contractType: fcsContractType,
                        crmReleaseGroupEntityId: crmReleaseGrpId,
                        releaseGroupName: releaseGroupName);

                    var crmFundingAllocationFKs = await getCrmFundingAllocationFKs();

                    await _crmReleaseGroupRepository.CreateReleaseGroup(
                        releaseGroupName: releaseGroupName,
                        fundingTypeId: crmFundingAllocationFKs.FundingTypeId,
                        fundingPeriodId: crmFundingAllocationFKs.PeriodId,
                        fspGroupId: crmFundingAllocationFKs.FspGroupId,
                        contractTypeId: crmFundingAllocationFKs.ContractTypeId,
                        crmReleaseGroupEntityId: crmReleaseGrpId.ToString());

                    return new ReleaseGroupId(paasReleaseGrpId, crmReleaseGrpId);
                });

            return releaseGroupId;
        }
    }
}
