namespace FundingAllocation.DataStore.Model
{
    public class ReleaseGroupGroup
    {
        private ReleaseGroupGroup()
        {
        }

        public ReleaseGroupGroup(int releaseGroupGroupId, int releaseGroupId)
        {
            ReleaseGroupGroupId = releaseGroupGroupId;
            ReleaseGroupId = releaseGroupId;
        }

        /// <summary>
        /// this is the ID of the group of release groups
        /// </summary>
        public int ReleaseGroupGroupId { get; private set; }
        public int ReleaseGroupId { get; private set; }
    }
}
