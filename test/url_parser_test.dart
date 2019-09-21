import 'package:sailor/src/url_parser/url_tree.dart';
import 'package:test/test.dart';

void main() {
  UrlTree<String> _tree;

  setUp(() {
    _tree = UrlTree<String>('/');
  });

  test('stores a simple url', () {
    final String url = '/magic/';
    _tree.addUrl(url, 'magic');
    expect(_tree.root.children.containsKey('magic'), isTrue);
  });

  test('stores 2 urls with same root', () {
    final String url1 = '/magic/1';
    final String url2 = '/magic/2';
    _tree.addUrl(url1, '1');
    _tree.addUrl(url2, '2');
    expect(_tree.root.children.containsKey('magic'), isTrue);
    expect(_tree.root.children['magic'].children.containsKey('1'), isTrue);
    expect(_tree.root.children['magic'].children.containsKey('2'), isTrue);
  });

  test('stores 2 urls with same different roots', () {
    final String url1 = '/abc/1';
    final String url2 = '/def/2';
    _tree.addUrl(url1, 'abc');
    _tree.addUrl(url2, 'def');
    expect(_tree.root.children['abc'].children.containsKey('1'), isTrue);
    expect(_tree.root.children['def'].children.containsKey('2'), isTrue);
  });
}
