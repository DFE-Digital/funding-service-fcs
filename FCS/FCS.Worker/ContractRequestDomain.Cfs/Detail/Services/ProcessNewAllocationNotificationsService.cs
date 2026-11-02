namespace ContractRequestDomain.Cfs.Detail.Services
{
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using ContractRequestDomain.Cfs.Detail.DTOs;
    using ContractRequestDomain.Cfs.Detail.Repositories;
    using ContractRequestDomain.Cfs.Common.Dtos;
    using SFA.FCT.ContractRequestDomain.DataStore.Model;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ProcessNewAllocationNotificationsService : IProcessNewAllocationNotificationsService
    {
        private readonly IAllocationNotificationRepository _allocationNotificationRepository;

        private readonly IAllocationDetailService _allocationDetailService;

        public ProcessNewAllocationNotificationsService(
            IAllocationNotificationRepository allocationNotificationRepository,
            IAllocationDetailService allocationDetailService)
        {
            _allocationNotificationRepository = allocationNotificationRepository;
            _allocationDetailService = allocationDetailService;
        }

        public async Task<AllocationWithEntityId[]> GetPopulatedNewAllocations(ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<AllocationNotification> allocationNotifications = await _allocationNotificationRepository.GetNewAllocationNotificationsThatAreNotInProgress(connectionInfo);

            IReadOnlyCollection<AllocationNotification> dedupedAllocationNotifications = allocationNotifications.ToDedupedList();

            List<Task<AllocationWithEntityId>> allocations = dedupedAllocationNotifications.Select(async a =>
                {
                    Allocation allocation = await _allocationDetailService.GetAllocationDetail(
                        allocationId: a.AllocationId,
                        version: a.VersionNumber);

                    return new AllocationWithEntityId(entityId: a.Id, allocation: allocation);
                }).ToList();

           return await Task.WhenAll(allocations);
        }
    }
}
