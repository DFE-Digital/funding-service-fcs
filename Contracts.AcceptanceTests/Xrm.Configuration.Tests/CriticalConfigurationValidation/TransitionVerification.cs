using CoreTechs.Common;
using Microsoft.PowerPlatform.Dataverse.Client;
using Microsoft.VisualStudio.TestTools.UnitTesting;
//using Microsoft.Xrm.Client;
//using Microsoft.Xrm.Client.Services;
using Microsoft.Xrm.Sdk;
//using Microsoft.Test.ObjectComparison;
using Microsoft.Xrm.Sdk.Query;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Xml.Linq;
using NUnit.Framework.Legacy;


namespace SFA.FCT.Xrm.Configuration.Tests.CriticalConfigurationValidation
{


    /// <summary>
    /// This class contains test to verfiy CRM Tranistion record against template stored under ConfigData/Transition XML
    /// It is import all transition are consistent across platform after each deployment
    /// </summary>
    /// 
    

    [TestClass]
    public class TransitionVerification : TestBase
    {
        public XDocument ConfigData;
        private readonly string _baseDirectoryName = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
        //private OrganizationService _service;
        private IOrganizationService _service;



        [TestMethod]
        [TestCategory("CRMConfiguration_onhold")]
        public void TransitionVerificationSettings()
        {

            //CrmConnection connection = new CrmConnection("CrmConnectionString");
            //_service = new OrganizationService(connection);


            string connectionString = ConfigurationManager.ConnectionStrings["CrmConnectionString"].ConnectionString;
            var serviceClient = new ServiceClient(connectionString);
            _service = serviceClient;

            string configDataFile = Path.Combine(_baseDirectoryName, @"ConfigData\Transition.xml");
            ConfigData = XDocument.Load(configDataFile);

            CompareTransition(_service);

        }

        public void CompareTransition(IOrganizationService service)
        {
           

            if (ConfigData.Root != null)
            {
                XElement transitionsData = ConfigData.Root.Element("Transitions");

                var ExpectedObjects =
                    from item in transitionsData.Descendants("TransitionRecord")
                    orderby item.Element("Name").Value
                    select new TransitionObject
                    {
                        Name = item.Element("Name").Value,
                        ManagersTeam = item.Element("ManagersTeam").Value,
                        Owner = item.Element("Owner").Value,
                        ActionOnExistingTask = item.Element("ActionOnExistingTask").Value,
                        FromAction = item.Element("FromAction").Value,
                        NextAction = item.Element("NextAction").Value,
                        FromState = item.Element("FromState").Value,
                        ToState = item.Element("ToState").Value,
                        ServiceIntent = item.Element("ServiceIntent").Value,
                        APICallRequired = item.Element("APICallRequired").Value,
                        RequiresANotification = item.Element("RequiresANotification").Value,
                        RequiresChangeOfOwnership = item.Element("RequiresChangeOfOwnership").Value,
                        RequiresCreationOfTask = item.Element("RequiresCreationOfTask").Value,
                        Subject = item.Element("Subject").Value,
                        TaskDescription = item.Element("TaskDescription").Value,
                        DefaultAssignTo = item.Element("DefaultAssignTo").Value,
                        NotificationType = item.Element("NotificationType").Value,
                        NotificationDescription = item.Element("NotificationDescription").Value,
                        NotificationSubject = item.Element("NotificationSubject").Value

                    };



                //using (var context = new CrmOrganizationServiceContext(service))
                //{
                //    var TransitionCollection = context.CreateQuery("sfa_transition") 
                //        .Where(c => c.GetAttributeValue<OptionSetValue>("statecode").Value == 0)
                //        .OrderBy(x=>x["sfa_name"])
                //        .ToList();

                //    List<TransitionObject> ActualObjects =  CreateactualTranistionOjbect(TransitionCollection);

                var query = new QueryExpression("sfa_transition")
                {
                    ColumnSet = new ColumnSet(true)
                };

                query.Criteria.AddCondition(
                    "statecode",
                    ConditionOperator.Equal,
                    0);

                query.AddOrder(
                    "sfa_name",
                    OrderType.Ascending);

                var transitionCollection =
                    service.RetrieveMultiple(query)
                           .Entities
                           .ToList();


                List<TransitionObject> ActualObjects =
                    CreateactualTranistionOjbect(transitionCollection);


                ClassicAssert.AreEqual(ExpectedObjects.Count(), ActualObjects.Count, string.Format("Expected Transition number : {0} is different to actual transition number : {1}.", ExpectedObjects.Count().ToString(), ActualObjects.Count.ToString()));
                    StringBuilder result = new StringBuilder();

                    foreach (var aTrans in ActualObjects)
                    {
                        var eTrans =
                            ExpectedObjects.Where(x => x.Name == aTrans.Name)
                                .FirstOrDefault();

                        var transitionName = aTrans.Name;

                        ClassicAssert.IsTrue(eTrans != null,
                            string.Format("Transition : {0} cannot be found in verification template.", transitionName));

                        

                      

                        foreach (PropertyInfo propertyInfo in eTrans.GetType().GetProperties())
                        {
                            var aResult = propertyInfo.GetValue(aTrans, null);
                            var eResult = propertyInfo.GetValue(eTrans, null);

                            if (aResult.ToString() != eResult.ToString())
                            {
                                result.AppendLine(
                                    string.Format(
                                        "Transition : {0} Expected {1} : {2} is different with Autual {3}: {4}",
                                        transitionName, propertyInfo.Name, eResult, propertyInfo.Name, aResult));
                            }
                        }
                    }

                    //IEnumerable<ObjectComparisonMismatch> mismatches = CompareTransitionReportObjects(ExpectedObjects, ActualObjects);
                    ClassicAssert.IsTrue(result.Length==0, result.ToString());

                //}
            }
        }

        //public string WriteMismatches(IEnumerable<ObjectComparisonMismatch> mismatches)
        //{

        //    StringBuilder sb = new StringBuilder();
        //    foreach (var mismatch in mismatches)
        //    {
        //        sb.AppendLine(string.Format(
        //            "Expected {0} value: {1}, Actual {2} value: {3}, Mismatch Type: {4}",
        //            mismatch.LeftObjectNode != null ? mismatch.LeftObjectNode.Name : null,
        //            mismatch.LeftObjectNode != null ? mismatch.LeftObjectNode.ObjectValue : null,
        //            mismatch.RightObjectNode != null ? mismatch.RightObjectNode.Name : null,
        //            mismatch.RightObjectNode != null ? mismatch.RightObjectNode.ObjectValue : null,
        //            mismatch.MismatchType));
        //    }

        //    return sb.ToString();
        //}

        public List<TransitionObject> CreateactualTranistionOjbect(IEnumerable<Entity> source)
        {
            List<TransitionObject> result = new List<TransitionObject>();

            foreach (var trans in source)
            {
                var newTransObj = new TransitionObject()
                {
                    Name = trans.GetAttributeValue<string>("sfa_name") ?? "",
                    ManagersTeam =  trans.GetAttributeValue<EntityReference>("sfa_managersteam") !=null? trans.GetAttributeValue<EntityReference>("sfa_managersteam").Name : "",
                    Owner = trans.GetAttributeValue<EntityReference>("owningteam") !=null ? GetFieldName("team", trans.GetAttributeValue<EntityReference>("owningteam").Id,"name"): GetFieldName("systemuser", trans.GetAttributeValue<EntityReference>("owninguser").Id,"name"),
                    //ActionOnExistingTask = trans.GetAttributeValue<OptionSetValue>("sfa_actionontask") != null ? trans.GetFormattedAttributeValue("sfa_actionontask") : "",
                    ActionOnExistingTask = trans.FormattedValues.Contains("sfa_actionontask")? trans.FormattedValues["sfa_actionontask"]: "",
                    FromAction = trans.GetAttributeValue<EntityReference>("sfa_fromaction") != null ? trans.GetAttributeValue<EntityReference>("sfa_fromaction").Name : "",
                    NextAction = trans.GetAttributeValue<EntityReference>("sfa_nextaction") != null ? trans.GetAttributeValue<EntityReference>("sfa_nextaction").Name : "",
                    //FromState =  trans.GetAttributeValue<OptionSetValue>("sfa_fromstate") != null ? trans.GetFormattedAttributeValue("sfa_fromstate") : "",
                    FromState = trans.FormattedValues.Contains("sfa_fromstate") ? trans.FormattedValues["sfa_fromstate"] : "",
                    //ToState = trans.GetAttributeValue<OptionSetValue>("sfa_tostate") != null ? trans.GetFormattedAttributeValue("sfa_tostate") : "",
                    ToState = trans.FormattedValues.Contains("sfa_tostate") ? trans.FormattedValues["sfa_tostate"] : "",
                    ServiceIntent = trans.GetAttributeValue<string>("sfa_serviceintent") ?? "",
                    APICallRequired = trans.GetAttributeValue<Boolean>("sfa_callapi") == true ? "True" : "False",
                    RequiresANotification = trans.GetAttributeValue<Boolean>("sfa_requiresanotification") == true ? "True" : "False",
                    RequiresChangeOfOwnership = trans.GetAttributeValue<Boolean>("sfa_requireschangeofownership") == true ? "True" : "False",
                    RequiresCreationOfTask = trans.GetAttributeValue<Boolean>("sfa_createtask") == true ? "True" : "False",
                    Subject = trans.GetAttributeValue<string>("sfa_subject")  ?? "",
                    TaskDescription = trans.GetAttributeValue<string>("sfa_taskdescription") ?? "",
                    //DefaultAssignTo = trans.GetAttributeValue<OptionSetValue>("sfa_defaultassignto") != null ? trans.GetFormattedAttributeValue("sfa_defaultassignto") : "",
                    DefaultAssignTo = trans.FormattedValues.Contains("sfa_defaultassignto") ? trans.FormattedValues["sfa_defaultassignto"] : "",
                    //NotificationType = trans.GetAttributeValue<OptionSetValue>("sfa_notificationtype") != null ? trans.GetFormattedAttributeValue("sfa_notificationtype") : "",
                    NotificationType = trans.FormattedValues.Contains("sfa_notificationtype") ? trans.FormattedValues["sfa_notificationtype"] : "",
                    NotificationDescription = trans.GetAttributeValue<string>("sfa_notificationdescription") ??  "",
                    NotificationSubject = trans.GetAttributeValue<string>("sfa_notificationsubject") ?? ""

                };

                result.Add(newTransObj);

             }


            return result;

        }

        public string GetFieldName(string entityName, Guid objectId, string namefield)
        {
            return _service.Retrieve(entityName, objectId, new ColumnSet(new String[]
            {
                namefield
            }
        )).GetAttributeValue<string>(namefield);

        }

        //public IEnumerable<ObjectComparisonMismatch> CompareTransitionReportObjects(object expectedTransitionObject, object actualTransitionObject)
        //{
        //    IEnumerable<ObjectComparisonMismatch> mismatches = new List<ObjectComparisonMismatch>();
        //    var factory = new PublicPropertyObjectGraphFactory();
        //    var comparer = new ObjectGraphComparer();

        //    var expectedGraph = factory.CreateObjectGraph(expectedTransitionObject);
        //    var actualGraph = factory.CreateObjectGraph(actualTransitionObject);

        //    comparer.Compare(expectedGraph, actualGraph, out mismatches);

        //    return mismatches;
        //}


    }



}
