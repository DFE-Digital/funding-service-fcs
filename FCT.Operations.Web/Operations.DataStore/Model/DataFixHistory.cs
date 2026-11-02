namespace Operations.DataStore.Model
{
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class DataFixHistory
    {
        private DataFixHistory()
        {
        }

        public DataFixHistory(string release, int storyNumber, string name)
        {
            Release = release;
            StoryNumber = storyNumber;
            Name = name;
        }

        [Key]
        public int Id { get; private set; }

        [Index("IX_DataFixHistory_ReleaseStoryNumberName", Order = 1, IsUnique = true)]
        [Required, MaxLength(10)]
        public string Release { get; private set; }

        [Index("IX_DataFixHistory_ReleaseStoryNumberName", Order = 2, IsUnique = true)]
        [Required]
        public int StoryNumber { get; private set; }

        [Index("IX_DataFixHistory_ReleaseStoryNumberName", Order = 3, IsUnique = true)]
        [Required, MaxLength(100)]
        public string Name { get; private set; }

        public string GetKey()
        {
            return $"{Release}{StoryNumber}{Name}".ToUpper();
        }
    }
}
