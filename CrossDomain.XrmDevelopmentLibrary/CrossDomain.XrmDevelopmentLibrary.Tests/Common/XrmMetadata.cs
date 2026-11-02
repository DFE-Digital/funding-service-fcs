using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.CrossDomain.XrmDevelopmentLibrary.Tests.Common
{
    public static class XrmMetadata
    {
        #region Team Entity

        internal const string Team = "team";
        internal const string TeamName = "name";

        #endregion

        #region Contract Allocation

        internal const string ContractAllocation = "sfa_contractallocation";
        internal const string ContractAllocationRef = "sfa_contractallocationnumber";

        #endregion

        #region Contract Entity

        internal const string Contract = "sfa_contract";
        internal const string ContractNumber = "sfa_number";
        internal const string ProviderName = "sfa_providername";

        #endregion

        #region Organisation Entity

        internal const string Organisation = "account";

        #endregion

        #region System User Entity

        internal const string SystemUser = "systemuser";

        #endregion

        #region Transition Entity

        internal const string Transition = "sfa_transition";
        internal const string TransitionName = "sfa_name";

        #endregion

        #region Status Entity

        internal const string Status = "sfa_status";
        internal const string StatusName = "sfa_name";

        #endregion

        #region Task Entity

        internal const string Task = "task";

        #endregion

        #region Common

        internal const string Owner = "ownerid";
        internal const string State = "statecode";
        internal const string StatusReason = "statuscode";
        internal const string Regarding = "regardingobjectid";

        #endregion
    }
}
