namespace SFA.FCT.PerformanceManagementDomain.DataStore.Repositories
{
    using System.Collections.Generic;
    using System.Linq;
    using Models;

    public class ContractAllocationDeliverableRepository : PerformanceManagementRepositoryBase<ContractAllocationDeliverable>, IContractAllocationDeliverableRepository
    {
        private readonly IPerformanceManagementDbContext _dbContext;

        public ContractAllocationDeliverableRepository(IPerformanceManagementDbContext dbContext)
            : base(dbContext.ContractAllocationDeliverables)
        {
            _dbContext = dbContext;
        }

        public ContractAllocationDeliverable Find(string contractAllocationNumber, int deliverableCode)
        {
            return FindByKey(new object[] {contractAllocationNumber, deliverableCode});
        }

        public IReadOnlyCollection<ContractAllocationDeliverable> FindByAllocationNumber(string contractAllocationNumber)
        {
            return
                _dbContext.ContractAllocationDeliverables.Where(
                    ad => ad.ContractAllocationNumber == contractAllocationNumber)
                    .ToList();
        }

        public void StoreContractAllocationDeliverables(IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables)
        {
            UpSertContractAllocationDeliverables(contractAllocationDeliverables);

            // now remove any deliverables that are not passed in
            string allocationNumber = contractAllocationDeliverables.FirstOrDefault()?.ContractAllocationNumber;
            if (allocationNumber != null)
            {
                IReadOnlyCollection<int> newDeliverableCodes =
                contractAllocationDeliverables.Select(newD => newD.DeliverableCode).ToList();

                // find deliverables that do not have one of these codes
                var deliverablesToRemove = _dbContext.ContractAllocationDeliverables.Where(
                    d => d.ContractAllocationNumber == allocationNumber)
                    .Where(
                        existingD =>
                            !newDeliverableCodes
                                .Contains(existingD.DeliverableCode)).ToList();

                deliverablesToRemove.ForEach(d => _dbContext.ContractAllocationDeliverables.Remove(d));
            }

            _dbContext.SaveChanges();
        }

        private void UpSertContractAllocationDeliverables(
            IReadOnlyCollection<ContractAllocationDeliverable> contractAllocationDeliverables)
        {
            contractAllocationDeliverables.ToList().ForEach(d =>
            {
                var existingDeliverable = _dbContext.ContractAllocationDeliverables.Find(d.ContractAllocationNumber,
                    d.DeliverableCode);

                if (existingDeliverable != null)
                {
                    existingDeliverable.PlannedValue = d.PlannedValue;
                }
                else
                {
                    _dbContext.ContractAllocationDeliverables.Add(d);
                }
            });
        }
    }
}
