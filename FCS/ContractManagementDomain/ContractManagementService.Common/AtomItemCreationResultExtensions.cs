namespace SFA.FCT.ContractManagementService.Common
{
    using System.Collections.Generic;
    using System.Linq;

    public static class AtomItemCreationResultExtensions
    {
        private static readonly IReadOnlyCollection<AtomItemCreationResult> AtomItemCreationResultsThatAreGoodToContinue = new List<AtomItemCreationResult>
        {
            AtomItemCreationResult.Added,
            AtomItemCreationResult.AlreadyPresent
        };

        public static bool IsGoodToContinue(this AtomItemCreationResult result)
        {
            return AtomItemCreationResultsThatAreGoodToContinue.Contains(result);
        }
    }
}
