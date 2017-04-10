import { TemplateAppPage } from './app.po';

describe('template-app App', () => {
  let page: TemplateAppPage;

  beforeEach(() => {
    page = new TemplateAppPage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
