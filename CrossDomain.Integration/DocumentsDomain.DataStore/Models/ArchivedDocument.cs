namespace SFA.FCT.DocumentsDomain.DataStore.Models
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public enum EventType
    {
        NotSet = 0,
        Approval = 1,
        Withdrawal = 2
    }

    public class ArchivedDocument
    {
        private ArchivedDocument()
        {
        }

        public ArchivedDocument(Guid key, string fileName, EventType eventType, string folderOrigin)
        {
            Key = key;
            FileName = fileName;
            EventType = eventType;
            FolderOrigin = folderOrigin;
        }

        [Key, Column(Order = 1)]
        public Guid Key { get; private set; }

        [MaxLength(150)]
        [Required]
        public string FileName { get; private set; }

        [Required]
        public EventType EventType { get; private set; }

        [MaxLength(150)]
        [Required]
        public string FolderOrigin { get; private set; }

        public override string ToString()
        {
            return
                $"Key: {Key}, FileName: {FileName}, EventType: {EventType}, FolderOrigin: {FolderOrigin}";
        }
    }
}