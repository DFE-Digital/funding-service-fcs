namespace SFA.FCT.ContractManagementService.Utils
{
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Xml.Linq;

    public class ContractXmlSearchHelper
    {
        private readonly string _xmlString;
        private readonly string _namespace;
        private XDocument _document;
        private XElement _firstContract;

        public ContractXmlSearchHelper(string xmlString, string namespaceString)
        {
            _xmlString = xmlString;
            _namespace = namespaceString;
        }

        public string GetElementValue(string elementName)
        {
            InitializeDocument();
            return _document.Descendants(XName.Get(elementName, @_namespace)).First().Value;   
        }

        public string GetFirstContractNumber()
        {
            InitializeDocument();

            var contract = GetFirstContract();

            if (contract == null)
            {                
                return null;  
            }

            return contract
                .Element(XName.Get("contractNumber", @_namespace))
                ?.Value;
        }


        public string GetFirstContractVersionNumber()
        {
            InitializeDocument();

            var contractVersionNumber = GetFirstContract();

            if (contractVersionNumber == null)
            {               
                return null; 
            }

            return contractVersionNumber
                .Element(XName.Get("contractVersionNumber", @_namespace))
                ?.Value;
        }

        private XElement GetFirstContract()
        {
            if (_firstContract == null)
            {
                _firstContract = _document.Root
                    .Descendants(XName.Get("contract", @_namespace))
                    .FirstOrDefault(c =>
                        (string)c.Element(XName.Get("hierarchyType", @_namespace)) == "CONTRACT"
                    );
            }

            return _firstContract;
        }

        private void InitializeDocument()
        {
            if (_document == null)
            {
                _document = XDocument.Parse(_xmlString);
            }
        }
    }
}