using Ciber.Xrm.Tests;

namespace FCTCrmConfig.Tests
{
    using System;
    using System.Configuration;
    using System.Data;
    using System.Xml;
    using Microsoft.VisualStudio.TestTools.UnitTesting;


    [TestClass]
    public class CrmConfigurationUser : TestBase
    {
        #region Entity
       
        #endregion

        #region Attributes


        [TestMethod]
        [TestCategory("CRMConfiguration")]
        [TestProperty("StoryNo", "84")]
        //Is there a field called Action Requested By on the Workflow History Entity
        public void WorkflowHistoryEntityHasActionRequestedFrom()
        {
            TestBase.CrmConfiguration.Entity("systemuser")
                .Relationship("sfa_contracttransitionhistory", "Action Requested From");
                
        }


        #endregion

        #region Forms

        #endregion

        #region Views

        
            #endregion
        }
    }

