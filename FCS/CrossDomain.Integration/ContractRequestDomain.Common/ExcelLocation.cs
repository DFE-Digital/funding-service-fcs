namespace SFA.FCT.ContractRequestDomain.Common
{
    using System;

    [Serializable]
    public class ExcelLocation
    {
        public virtual string CorrelationId { get; set; }

        public virtual string Sheet { get; set; }

        public virtual int Row { get; set; }

        public virtual string ParentId { get; set; }

        public virtual string ContractRequestId { get; set; }

        public override string ToString()
        {
            return
                "ExcelLocation: " +
                "ContractRequestId: [" + ContractRequestId + "] " +
                "CorrelationId: [" + CorrelationId + "] " +
                "ParentId: " + ParentId + "] " +
                "Sheet: [" + Sheet + "] " +
                "Row: [" + Row + "]";
        }
    }
}