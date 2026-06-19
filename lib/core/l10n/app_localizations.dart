import 'strings_en.dart';
import 'strings_hi.dart';

enum AppLocale { en, hi }

class AppLocalizations {
  final AppLocale locale;
  const AppLocalizations(this.locale);

  bool get isHindi => locale == AppLocale.hi;

  // Nav
  String get navHome => isHindi ? StringsHi.navHome : StringsEn.navHome;
  String get navAbout => isHindi ? StringsHi.navAbout : StringsEn.navAbout;
  String get navServices => isHindi ? StringsHi.navServices : StringsEn.navServices;
  String get navTestimonials => isHindi ? StringsHi.navTestimonials : StringsEn.navTestimonials;
  String get navContact => isHindi ? StringsHi.navContact : StringsEn.navContact;
  String get navBookNow => isHindi ? StringsHi.navBookNow : StringsEn.navBookNow;

  // Hero
  String get heroLabel => isHindi ? StringsHi.heroLabel : StringsEn.heroLabel;
  String get heroName => isHindi ? StringsHi.heroName : StringsEn.heroName;
  String get heroNameAlt => isHindi ? StringsHi.heroNameAlt : StringsEn.heroNameAlt;
  String get heroTagline => isHindi ? StringsHi.heroTagline : StringsEn.heroTagline;
  String get heroTaglineAlt => isHindi ? StringsHi.heroTaglineAlt : StringsEn.heroTaglineAlt;
  String get heroCtaPrimary => isHindi ? StringsHi.heroCtaPrimary : StringsEn.heroCtaPrimary;
  String get heroCtaSecondary => isHindi ? StringsHi.heroCtaSecondary : StringsEn.heroCtaSecondary;

  // Stats
  String get statYears => isHindi ? StringsHi.statYears : StringsEn.statYears;
  String get statYearsLabel => isHindi ? StringsHi.statYearsLabel : StringsEn.statYearsLabel;
  String get statClients => isHindi ? StringsHi.statClients : StringsEn.statClients;
  String get statClientsLabel => isHindi ? StringsHi.statClientsLabel : StringsEn.statClientsLabel;
  String get statCities => isHindi ? StringsHi.statCities : StringsEn.statCities;
  String get statCitiesLabel => isHindi ? StringsHi.statCitiesLabel : StringsEn.statCitiesLabel;

  // About page
  String get aboutBannerLabel => isHindi ? StringsHi.aboutBannerLabel : StringsEn.aboutBannerLabel;
  String get aboutBannerTitle => isHindi ? StringsHi.aboutBannerTitle : StringsEn.aboutBannerTitle;
  String get aboutBannerSubtitle => isHindi ? StringsHi.aboutBannerSubtitle : StringsEn.aboutBannerSubtitle;
  String get aboutMyJourney => isHindi ? StringsHi.aboutMyJourney : StringsEn.aboutMyJourney;
  String get aboutPhilosophyLabel => isHindi ? StringsHi.aboutPhilosophyLabel : StringsEn.aboutPhilosophyLabel;
  String get aboutMilestonesLabel => isHindi ? StringsHi.aboutMilestonesLabel : StringsEn.aboutMilestonesLabel;
  String get aboutMilestonesTitle => isHindi ? StringsHi.aboutMilestonesTitle : StringsEn.aboutMilestonesTitle;
  String get aboutReadFullStory => isHindi ? StringsHi.aboutReadFullStory : StringsEn.aboutReadFullStory;
  String get aboutBeginJourney => isHindi ? StringsHi.aboutBeginJourney : StringsEn.aboutBeginJourney;
  String get aboutBeginBody => isHindi ? StringsHi.aboutBeginBody : StringsEn.aboutBeginBody;

  // Services page
  String get servicesBannerLabel => isHindi ? StringsHi.servicesBannerLabel : StringsEn.servicesBannerLabel;
  String get servicesBannerTitle => isHindi ? StringsHi.servicesBannerTitle : StringsEn.servicesBannerTitle;
  String get servicesBannerSubtitle => isHindi ? StringsHi.servicesBannerSubtitle : StringsEn.servicesBannerSubtitle;
  String get servicesProcessLabel => isHindi ? StringsHi.servicesProcessLabel : StringsEn.servicesProcessLabel;
  String get servicesProcessTitle => isHindi ? StringsHi.servicesProcessTitle : StringsEn.servicesProcessTitle;
  String get servicesScheduleNow => isHindi ? StringsHi.servicesScheduleNow : StringsEn.servicesScheduleNow;
  String get servicesBookingTitle => isHindi ? StringsHi.servicesBookingTitle : StringsEn.servicesBookingTitle;
  String get servicesBookingBody => isHindi ? StringsHi.servicesBookingBody : StringsEn.servicesBookingBody;
  String get servicesViewAll => isHindi ? StringsHi.servicesViewAll : StringsEn.servicesViewAll;

  // Testimonials page
  String get testimonialsBannerLabel => isHindi ? StringsHi.testimonialsBannerLabel : StringsEn.testimonialsBannerLabel;
  String get testimonialsBannerTitle => isHindi ? StringsHi.testimonialsBannerTitle : StringsEn.testimonialsBannerTitle;
  String get testimonialsBannerSubtitle => isHindi ? StringsHi.testimonialsBannerSubtitle : StringsEn.testimonialsBannerSubtitle;
  String get testimonialsBookingTitle => isHindi ? StringsHi.testimonialsBookingTitle : StringsEn.testimonialsBookingTitle;
  String get testimonialsBookingBody => isHindi ? StringsHi.testimonialsBookingBody : StringsEn.testimonialsBookingBody;
  String get testimonialsViewAll => isHindi ? StringsHi.testimonialsViewAll : StringsEn.testimonialsViewAll;

  // Contact page
  String get contactBannerLabel => isHindi ? StringsHi.contactBannerLabel : StringsEn.contactBannerLabel;
  String get contactBannerTitle => isHindi ? StringsHi.contactBannerTitle : StringsEn.contactBannerTitle;
  String get contactBannerSubtitle => isHindi ? StringsHi.contactBannerSubtitle : StringsEn.contactBannerSubtitle;
  String get contactFaqLabel => isHindi ? StringsHi.contactFaqLabel : StringsEn.contactFaqLabel;
  String get contactFaqTitle => isHindi ? StringsHi.contactFaqTitle : StringsEn.contactFaqTitle;
  String get contactSendRequest => isHindi ? StringsHi.contactSendRequest : StringsEn.contactSendRequest;
  String get contactSendMessage => isHindi ? StringsHi.contactSendMessage : StringsEn.contactSendMessage;
  String get contactReachOut => isHindi ? StringsHi.contactReachOut : StringsEn.contactReachOut;
  String get contactSuccessTitle => isHindi ? StringsHi.contactSuccessTitle : StringsEn.contactSuccessTitle;
  String get contactSuccessBody => isHindi ? StringsHi.contactSuccessBody : StringsEn.contactSuccessBody;

  // Common CTAs
  String get ctaBookConsultation => isHindi ? StringsHi.ctaBookConsultation : StringsEn.ctaBookConsultation;
  String get ctaExploreServices => isHindi ? StringsHi.ctaExploreServices : StringsEn.ctaExploreServices;
}
