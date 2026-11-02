using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Xrm.Configuration.Tests.Claim_Recon_Alloc_Group
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    [TestClass]
    public partial class XrmConfigurationAllocationGroup : TestBase
    {
        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15127")]
        public void XrmConfigurationAllocationGroupEntityExists()
        {
            CrmConfiguration.Entity("sfa_claimreconallocgroup")
                .HasDisplayName("Claim Recon Alloc Group");
        }
    }
}
