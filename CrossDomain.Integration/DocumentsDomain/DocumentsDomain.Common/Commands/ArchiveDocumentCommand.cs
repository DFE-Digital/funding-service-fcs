namespace SFA.FCT.DocumentsDomain.Common.Commands
{
    using System;

    public class ArchiveDocumentCommand
    {
        public Guid Key { get; set; }

        public string FileName { get; set; }

        public ContractAmendmentType AmendmentType { get; set; }

        public EventType EventType { get; set; }

        public string FolderOrigin { get; set; }

        public override string ToString()
        {
            return $"FolderOrigin: {FolderOrigin}, FileName: {FileName}, AmendmentType: {AmendmentType.ToString()}, EventType: {EventType.ToString()}.";
        }
    }

    public enum EventType
    {
        NotSet = 0,
        Approval = 1,
        Withdrawal = 2
    }
}