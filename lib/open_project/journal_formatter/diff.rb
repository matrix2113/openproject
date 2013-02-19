require_dependency 'journal_formatter/base'

class OpenProject::JournalFormatter::Diff < JournalFormatter::Base
  unloadable

  def render(key, values, no_html = false)
    render_ternary_detail_text(key, values.last, values.first, no_html)
  end

  private

  def label(key, no_html)
    label = super key

    no_html ?
      label :
      content_tag('strong', label)
  end

  def render_ternary_detail_text(key, value, old_value, no_html)
    link = link(key, no_html)

    label = label(key, no_html)

    if value.blank?
      l(:text_journal_deleted_with_diff, :label => label, :link => link)
    else
      unless old_value.blank?
        l(:text_journal_changed_with_diff, :label => label, :link => link)
      else
        l(:text_journal_set_with_diff, :label => label, :link => link)
      end
    end
  end

  # url_for wants to access the controller method, which we do not have in our Diff class.
  # see: http://stackoverflow.com/questions/3659455/is-there-a-new-syntax-for-url-for-in-rails-3
  def controller; @controller; end

  def link(key, no_html)
    url_attr = { :controller => 'journals',
                 :action => 'diff',
                 :id => @journal.id,
                 :field => key.downcase,
                 :only_path => false,
                 :protocol => Setting.protocol,
    # the link params should better be defined with the
    # skip_relative_url_root => true
    # option. But this method is flawed in 2.3
    # revise when on 3.2
                 :host => Setting.host_name.gsub(Redmine::Utils.relative_url_root.to_s, "") }

    if no_html
      url_for url_attr
    else
      link_to(l(:label_details),
                url_attr,
                :class => 'description-details')
    end
  end
end

