# Inline form-field error messages

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if html_tag =~ /type="hidden"/ || html_tag =~ /<label/
    html_tag
  else
    error_messages_tag = instance.error_message.join("</br>")
    %{<div class="field-with-errors">
        #{html_tag}
        <span class="error text-danger text-capitalize">
          #{error_messages_tag}
        </span>
      </div>
    }.html_safe
  end
end