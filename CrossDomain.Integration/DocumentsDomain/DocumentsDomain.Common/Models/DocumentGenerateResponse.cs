namespace SFA.FCT.DocumentsDomain.Common.Models
{
    using System;
    using System.Xml.Serialization;

    [Serializable]
    public class DocumentGenerateResponse
    {
        [XmlElement]
        public string TargetContainer { get; set; }

        [XmlElement]
        public string TargetFilename { get; set; }
    }
}
