class InfoPageModel {
  final String title;
  final String description;
  final List<String>? bullets;
  final String? footer;

  InfoPageModel({
    required this.title,
    required this.description,
    this.bullets,
    this.footer,
  });

  static final List<InfoPageModel> pages = [
    // 1
    InfoPageModel(
      title: '👋 Welcome to Goldexia_FX',
      description:
          'Goldexia_FX is a professional gold-trading platform designed to help traders grow their accounts through disciplined, data-driven trading signals.',
      bullets: [
        'Our mission is to provide consistent, high-quality trade ideas',
        'We offer structured earning opportunities for both individual traders and team builders',
      ],
      footer:
          'Start your journey with Goldexia_FX and experience smart, data-driven trading.',
    ),

    //2
    InfoPageModel(
      title: '📊 Trade with Confidence',
      description:
          'To experience the true performance of our system, we strongly recommend:',
      bullets: [
        'Follow only Goldexia_FX trading signals',
        'Avoid self-trading or signals from other mentors at least for 1 month',
        'Maintain this discipline for one full month',
        'Then evaluate the growth and consistency of your trading account',
      ],
      footer:
          'This approach allows you to accurately measure the effectiveness of our strategy.',
    ),

    //3
    InfoPageModel(
      title: '🤝 Build Your Trading Team & Earn More',
      description: 'Goldexia_FX gives you the opportunity to:',
      bullets: [
        'Create your own trading team of friends and relatives',
        'Earn commissions, prizes, and rewards based on team activity',
        'Scale your earnings beyond personal trading',
      ],
      footer:
          'To activate team benefits, simply create your trading account through our BlackBull Markets partner link.',
    ),

    //4
    InfoPageModel(
      title: '💰 Earn Even Without a Team',
      description: 'If you prefer to trade individually:',
      bullets: [
        'You can still qualify for commissions and rewards based on your own trading performance',
        'Create your trading account using BlackBull Markets client link',
        'Create your trading account using Exness client link',
      ],
      footer:
          'Goldexia_FX ensures value for both team builders and solo traders.',
    ),

    //5
    InfoPageModel(
      title: '🔐 Premium Signal Access\n(Without Team Membership',
      description: 'If you do not wish to join our team program:',
      bullets: [
        'You may subscribe to our premium signal service',
        'Access is granted after payment of the package fee',
        'You will still receive the same professional trade signals',
      ],
      footer:
          'Premium access ensures high-quality, professional trading signals without team obligations.',
    ),

    //6
    InfoPageModel(
      title: '🎬 Step-by-Step Video Tutorials',
      description: 'We provide clear video guides covering:',
      bullets: [
        'How to create a trading account through our partner links',
        'How to execute and manage Goldexia_FX signals correctly',
      ],
      footer:
          'These tutorials are designed for both beginners and experienced traders.',
    ),

    // 7
    InfoPageModel(
      title: '📞 Support & Assistance',
      description:
          'If you need help or have any questions, our support team is always available.',
      bullets: ['https://wa.me/message/OZA3JRVNIHD2I1'],
      footer:
          'Thank you for choosing Goldexia_FX\n\nTrade smart. Trade disciplined. Trade with professionals.',
    ),
  ];
}
