using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

namespace SFA.FCT.ContractCreateDomain.WebTest.Controllers
{
    using System.Web.Mvc;
    using System.Xml;
    using System.Xml.Serialization;
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Events;
    using System.Diagnostics.CodeAnalysis;
    using SFA.FCT.CrossDomain.Integration.Messages.Commands;

    [ExcludeFromCodeCoverage]
    public class HomeController : Controller
    {
        public ActionResult NewContract()
        {

            NewContractRequestCommand message = new NewContractRequestCommand
            {
                ContractRequest = CreateContractRequestType()
            };
            ServiceBus.Bus.Send(message);
            return Json(new { sent = message });
        }
        protected override JsonResult Json(object data,
         string contentType,
         System.Text.Encoding contentEncoding,
         JsonRequestBehavior behavior)
        {
            return base.Json(data, contentType, contentEncoding,
            JsonRequestBehavior.AllowGet);
        }

        private contractRequestType CreateContractRequestType()
        {
            using (
                FileStream fileStream = new FileStream(Server.MapPath("..\\Resources\\ContractRequest.bin"),
                    FileMode.Open))
            {
                BinaryFormatter bf = new BinaryFormatter();
                return bf.Deserialize(fileStream) as contractRequestType;
            };

            //XmlDocument document = new XmlDocument();
            //document.Load(Server.MapPath("..\\..\\Resources\\ContractRequest.xml"));

            //XmlSerializer serializer = new XmlSerializer(typeof(contractRequestType));

            //contractRequestType crType = (contractRequestType)serializer.Deserialize(new XmlNodeReader(document));

            //  the deserialized obj does not contain period data
            //AddMissingValues(crType);

            //return crType;
        }

        private void AddMissingValues(contractRequestType crType)
        {
            const string periodStr = "1516";
            foreach (var contract in crType.contract.contracts)
            {
                contract.period.period = periodStr;
                foreach (var alloc in contract.contractAllocations)
                {
                    alloc.period.period = periodStr;
                }
            }
        }
    }
}