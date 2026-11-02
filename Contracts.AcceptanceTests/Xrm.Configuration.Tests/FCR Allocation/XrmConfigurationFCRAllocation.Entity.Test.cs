using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Xrm.Configuration.Tests.FCR_Allocation
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;



    [TestClass]
    public partial class XrmConfigurationFCRAllocation : TestBase
    {

        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "15127")]
        public void XrmConfigurationFCRAllocationEntityExists()
        {
            CrmConfiguration.Entity("sfa_fcrallocation")
                .HasDisplayName("FCR Allocation");
        }
    }
}
