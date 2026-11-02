namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;

    public class UploadedDocumentTemplate
    {
        public UploadedDocumentTemplate(string templateName, byte[] checksum, DateTime dateUpLoaded)
        {
            TemplateName = templateName;
            Checksum = checksum;
            DateUpLoaded = dateUpLoaded;
        }

        private UploadedDocumentTemplate()
        { }

        [Key, MaxLength(100)]
        public string TemplateName { get; private set; }

       [Required]
        public byte[] Checksum { get; private set; }

        public DateTime DateUpLoaded { get; private set; }
    }
}