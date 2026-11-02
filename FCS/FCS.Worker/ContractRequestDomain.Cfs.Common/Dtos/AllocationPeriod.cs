namespace ContractRequestDomain.Cfs.Common.Dtos
{
    public class AllocationPeriod
    {
        /// <summary>
        /// 1 equates to Jan ...
        /// </summary>
        public int Month { get; set; }

        public int Year { get; set; }

        public decimal ProfileValue { get; set; }

        /// <summary>
        /// e.g. "Jan-19"
        /// </summary>
        public string Period { get; set; }
    }
}