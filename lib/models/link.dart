// Data Model to keep things organized
class LinkItem {
  final String title;
  final String url;
  final String description;

  LinkItem({
    required this.title,
    required this.url,
    required this.description,
  });

    // Define the data list here with the updated descriptions
  static final List<LinkItem> items = [
    LinkItem(
      title: 'BlackBull Partner Account',
      url: 'https://partners.blackbull.com/en/apply/?cmp=5p0z2d3q&refid=6858',
      description:
          'Join BlackBull as a partner by building your own trading team. Invite your friends to trade using your partner link to earn commissions and exciting rewards and profits.',
    ),
    LinkItem(
      title: 'BlackBull Client Account',
      url: 'https://blackbull.com/en/live-account/?cmp=5p0z2d3q&refid=6858',
      description:
          'Open an individual BlackBull trading account using this link. Trade independently and get a chance to win exciting rewards and profits.',
    ),
    LinkItem(
      title: 'Exness Client Account',
      url: 'https://one.exnessonelink.com/a/l3q402vwrz',
      description:
          'For traders who prefer Exness, use this client link to create your account, start trading, and unlock exciting rewards and profits.',
    ),
  ];

}