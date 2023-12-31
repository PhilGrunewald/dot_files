#!/Users/pg/.config/python/ai/bin/python

import sys
import warnings
import vobject

def get_invitation_from_path(path):
    with open(path) as f:
        try:
            # vobject uses deprecated Exceptions
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                return vobject.readOne(f, ignoreUnreadable=True)
        except AttributeError:
            return vobject.readOne(f, ignoreUnreadable=True)


def person_string(c):
    name = ''
    if 'CN' in c.params.keys():
        name = (f"{c.params['CN'][0]} <{c.value.split(':')[1]}>")
    return name


def when_str_of_start_end(s, e):
    date_format = "%a, %d %b %Y at %H:%M"
    until_format = "%H:%M" if s.date() == e.date() else date_format
    return "%s -- %s" % (s.strftime(date_format), e.strftime(until_format))


def pretty_print_invitation(invitation):
    event = invitation.vevent.contents
    title = event['summary'][0].value
    line = "="*50
    organiser = ''
    if 'organiser' in event.keys():
        organiser = (f"By : {event['organizer'][0]}")
    invitees = event['attendee']
    start = event['dtstart'][0].value
    end = event['dtend'][0].value
    location = ''
    if 'location' in event.keys():
        location = (f"Place:\t{event['location'][0].value}")
    description = ''
    if 'description' in event.keys():
        description = (f"{line}\n{event['description'][0].value}")
    print(line)
    print(f"{title}".center(50))
    print(organiser)
    print("With:", end='')
    for i in invitees:
        print(f"\t{person_string(i)}")
    print(f"Time:\t{when_str_of_start_end(start, end)}")
    print(location)
    print(description)
    print(line)


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1].startswith('-'):
        sys.stderr.write("Usage: %s <filename.ics>\n" % sys.argv[0])
        sys.exit(2)
    inv = get_invitation_from_path(sys.argv[1])
    pretty_print_invitation(inv)
