{
  :results => @feeds_count,
  :rows => (
    collection (@feeds, :only => [:id]) { |feed|
      originator = feed.originator || feed.originator_type.constantize # If originator is deleted, it's class name will be used for calling methods

      {
        :user      => feed.participant.try(:feed_title) || feed.data[:current_user_identity] ,
        :object    => originator.title_with_img(feed.data[:originator_identity]),
        :operation => feed.data[:action_string].gsub('logged ',''),
        :tags      => originator.class.name == "Document" ? feed.originator.all_tags.join(",   ") : "",
        :date      => feed.created_at.strftime("%Y-%m-%d"),
        :time      => feed.created_at.strftime("%H:%M:%S"),
        :status    => !feed.failure ? content_tag(:b, 'success') : content_tag(:b, 'failure')
      }
    }
  )
}
