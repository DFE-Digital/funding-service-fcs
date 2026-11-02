using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Xrm.Configuration.Tests.FCR_Allocation_Deliverable
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;



    [TestClass]
    public partial class XrmConfigurationFCRAllocationDeliverable : TestBase
    {

        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15127")]
        public void XrmConfigurationFCRAllocationDeliverableEntityExists()
        {
            CrmConfiguration.Entity("sfa_fcrallocationdeliverable")
                .HasDisplayName("FCR Allocation Deliverable");
        }
    }
}
