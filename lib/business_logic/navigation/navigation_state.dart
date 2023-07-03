part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  final NavbarItem navbarItem;
  final int index;
  final String title;

  const NavigationState(this.navbarItem, this.index, this.title);

  @override
  List<Object> get props => [navbarItem, index];
}